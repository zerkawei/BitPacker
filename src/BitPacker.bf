using System;
using System.Collections;
namespace BitPacker;

public static class BitPacker
{
	public static void DefaultPacker(BitPosition[] positions)
	{
		int currentAlignement = 0;
		int currentOffset = 0;
		int currentByte = 0;
		
		List<int> sortedIndices = scope .(Range(0, positions.Count).GetEnumerator());
		sortedIndices.Sort((a, b) => positions[b].BitSize <=> positions[a].BitSize);

		int i = 0;
		while(sortedIndices.Count > 0)
		{
			ref BitPosition current = ref positions[sortedIndices[i]];

			if(current.BitSize + currentOffset > (currentAlignement << 3))
			{
				currentByte += currentAlignement;
				currentAlignement = current.ByteSize;
				currentOffset = 0;
			}

			current.Byte   = (.)currentByte;
			current.Offset = (.)currentOffset;

			currentOffset += current.BitSize;
			sortedIndices.RemoveAt(i--);

			repeat { i++; } while(i < sortedIndices.Count && positions[sortedIndices[i]].BitSize + currentOffset > (currentAlignement << 3));
			if(i >= sortedIndices.Count)
			{
				i = 0;
			}
		}
	}

	private const int[64] tab64 = .(
	    63,  0, 58,  1, 59, 47, 53,  2,
	    60, 39, 48, 27, 54, 33, 42,  3,
	    61, 51, 37, 40, 49, 18, 28, 20,
	    55, 30, 34, 11, 43, 14, 22,  4,
	    62, 57, 46, 52, 38, 26, 32, 41,
	    50, 36, 17, 19, 29, 10, 13, 21,
	    56, 45, 25, 31, 35, 16,  9, 12,
	    44, 24, 15,  8, 23,  7,  6,  5);

	internal static int log2_64 (uint64 value)
	{
		var value;
	    value |= value >> 1;
	    value |= value >> 2;
	    value |= value >> 4;
	    value |= value >> 8;
	    value |= value >> 16;
	    value |= value >> 32;
	    return tab64[((uint64)((value - (value >> 1))*0x07EDD5E59A4E28C2)) >> 58];
	}
}