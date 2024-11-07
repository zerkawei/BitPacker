using System;
namespace BitPacker;

public class BitPackedType
{
	private BitPosition[] fields ~ delete _;
	private int size = 0;

	public this(BitPosition[] fields)
	{
		this.fields = fields;
		for(let f in fields)
		{
			if(f.Offset == 0)
			{
				size += f.ByteSize;
			}
		}
	}

	public this<T>(BitPosition[] sizes, T packer) where T : delegate void(BitPosition[] sizes)
	{
		packer(sizes);
		this.fields = sizes;
		for(let f in fields)
		{
			if(f.Offset == 0)
			{
				size += f.ByteSize;
			}
		}
	}

	public int Size => size;

	public T Get<T>(Span<uint8> instance, int field) where T : operator explicit uint
	{	
		let position = fields[field];
		let address = instance.Ptr + position.Byte;

		uint shifted = 0;
		uint mask = (1 << (position.BitSize)) - 1;

		switch(position.Alignement)
		{
		case 1:
			shifted = (*address) >> position.Offset;
		case 2:
			shifted = (*(uint16*)address) >> position.Offset;
		case 4:
			shifted = (*(uint32*)address) >> position.Offset;
		case 8:
			shifted = (*(uint64*)address) >> position.Offset;
		}

		return (.)(shifted & mask);
	}

	public void Set<T>(Span<uint8> instance, int field, T value) where uint : operator explicit T
	{
		let position = fields[field];
		let address = instance.Ptr + position.Byte;

		uint mask = ((1 << (position.BitSize)) - 1) << position.Offset;
		uint shifted = (uint)(value) << position.Offset;

		switch(position.Alignement)
		{
		case 1:
			(*address)          = (.)shifted & (uint8)mask  | ~(uint8)mask & (*address);
		case 2:
			(*(uint16*)address) = (.)shifted & (uint16)mask | ~(uint16)mask & (*(uint16*)address);
		case 4:
			(*(uint32*)address) = (.)shifted & (uint32)mask | ~(uint32)mask & (*(uint32*)address);
		case 8:
			(*(uint64*)address) = (.)shifted & (uint64)mask | ~(uint64)mask & (*(uint64*)address);
		}
	}
}