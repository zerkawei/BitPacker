using System;
using internal BitPacker;
namespace BitPacker;

public enum FieldDefintion
{
	case Bits(uint8 size);
	case IntRange(int min, int max);
	case Enum(Type enumType);
	case Bool;

	public uint8 BitSize
	{
		get
		{
			switch(this)
			{
			case Bits(let size):
				return size;
			case IntRange(let min, let max):
				return (.)BitPacker.log2_64((.)(max - min + 1)) + 1;
			case Enum(let enumType):
				return (.)BitPacker.log2_64((.)(enumType.FieldCount)) + 1;
			case Bool:
				return 1;
			}	
		}
	}
}

public class TypedPackingScheme : PackingScheme
{
	public FieldDefintion[] fieldDefs ~ delete _;

	public this(params FieldDefintion[] fields) : this(=> BitPacker.DefaultPacker, params fields) {}
	public this<T>(T packer, params FieldDefintion[] fields) where T : delegate void(BitPosition[] sizes)
	{
		this.fields = new BitPosition[fields.Count];
		fieldDefs = new FieldDefintion[fields.Count];

		fields.CopyTo(fieldDefs);

		for(let i < fields.Count)
		{
			this.fields[i] = .((.)fields[i].BitSize);
		}
		packer(this.fields);
		ComputeSize();
	}

	public override Variant Get(uint8* instance, int field)
	{
		var value = fields[field].GetFrom(instance);
		switch(fieldDefs[field])
		{
		case .Bits(?):
			return .Create(value);
		case .IntRange(let min, ?):
			return .Create((int)value + min);
		case .Enum(let enumType):
			return .Create(enumType, &value);
		case .Bool:
			return .Create(typeof(bool), &value);
		}
	}

	public override void Set(uint8* instance, int field, Variant value)
	{
		uint bits = 0;
		switch(fieldDefs[field])
		{
		case .Bits(let size):
			bits = value.Get<uint>();
		case .IntRange(let min, ?):
			bits = (.)(value.Get<int>() - min);
		case .Enum(let enumType):
			switch(enumType.Size)
			{
			case 1:
				bits = (.)value.Get<uint8>();
			case 2:
				bits = (.)value.Get<uint16>();
			case 4:
				bits = (.)value.Get<uint32>();
			case 8:
				bits = (.)value.Get<uint64>();
			}
		case .Bool:
			bits = value.Get<uint8>();
		}
		fields[field].SetIn(instance, bits);
	}

}