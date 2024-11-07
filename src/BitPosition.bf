using System;
namespace BitPacker;

public struct BitPosition
{
	public uint16 Byte;
	public uint8  Offset;
	public uint8  BitSize;

	public this(uint8 size) : this(size, uint16.MaxValue, 0) {}
	public this(uint8 size, uint16 byte, uint8 offset)
	{
		Byte      = byte;
		Offset    = offset;
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

	public override void ToString(String strBuffer)
	{
		strBuffer.AppendF("[{}]@{}+{}", BitSize, Byte, Offset);
	}
}