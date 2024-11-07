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
}