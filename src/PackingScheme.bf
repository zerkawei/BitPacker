using System;
namespace BitPacker;

public class PackingScheme
{
	private BitPosition[] fields ~ delete _;
	private int size;

	public this(BitPosition[] fields)
	{
		this.fields = fields;
		ComputeSize();
	}

	public this(params uint8[] sizes) : this(=> BitPacker.DefaultPacker, params sizes) {}
	public this<T>(T packer, params uint8[] sizes) where T : delegate void(BitPosition[] sizes)
	{
		fields = new BitPosition[sizes.Count];
		for(let i < sizes.Count)
		{
			fields[i] = .((.) sizes[i]);
		}
		packer(fields);
		ComputeSize();
	}

	public int Size => size;

	private void ComputeSize()
	{
		size = 0;
		for(let f in fields)
		{
			if(f.Offset == 0)
			{
				size += f.ByteSize;
			}
		}
	}

	public virtual Variant Get(Span<uint8> instance, int field) => .Create(fields[field].GetFrom(instance.Ptr));
	public virtual void Set(Span<uint8> instance, int field, Variant value) => fields[field].SetIn(instance.Ptr, value.Get<uint>());
}