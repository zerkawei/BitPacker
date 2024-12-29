using System;
namespace BitPacker;

public struct BitPosition
{
	public uint16 Byte;
	public uint8  Offset;
	public uint8  BitSize;

	public this(uint8 size, uint16 byte = uint16.MaxValue, uint8 offset = 0)
	{
		Byte    = byte;
		Offset  = offset;
		BitSize = size;
	}

	[Inline]
	public bool IsPositioned => Byte != uint16.MaxValue;
	public int  ByteSize     => ByteSizeOf(BitSize);
	public int  Alignement   => ByteSizeOf(BitSize + Offset);

	private static int ByteSizeOf(uint8 bitSize)
	{
		if((bitSize & 0x80) != 0) return 32; 
		if((bitSize & 0x40) != 0) return 16;
		if((bitSize & 0x20) != 0) return 8;
		if((bitSize & 0x10) != 0) return 4;
		if((bitSize & 0x08) != 0) return 2;
		return 1;
	}

	public uint GetFrom(uint8* bytes)
	{
		let address = bytes + Byte;

		uint shifted = 0;
		uint mask = (1 << (BitSize)) - 1;

		switch(Alignement)
		{
		case 1:
			shifted = (*address) >> Offset;
		case 2:
			shifted = (*(uint16*)address) >> Offset;
		case 4:
			shifted = (*(uint32*)address) >> Offset;
		case 8:
			shifted = (*(uint64*)address) >> Offset;
		}

		return (.)(shifted & mask);
	}

	public void SetIn(uint8* bytes, uint value)
	{
		let address = bytes + Byte;

		uint mask = ((1 << (BitSize)) - 1) << Offset;
		uint shifted = (uint)(value) << Offset;

		switch(Alignement)
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

	public override void ToString(String strBuffer)
	{
		strBuffer.AppendF("[{}]@{}+{}", BitSize, Byte, Offset);
	}
}