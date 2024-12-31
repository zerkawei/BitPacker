using System;
using System.Diagnostics;
namespace BitPacker;

public class PackArray
{
	private PackingScheme scheme;
	private int count;
	private uint8* ptr;

	public this(PackingScheme scheme, int count, uint8* ptr)
	{
		this.scheme = scheme;
		this.count = count;
		this.ptr = ptr;
	}

	[AllowAppend]
	public this(PackingScheme scheme, int count)
	{
		let ptr = append uint8[scheme.Size*count]*;
		this.scheme = scheme;
		this.count = count;
		this.ptr = ptr;
	}

	public PackingScheme Scheme => scheme;
	public int Count => count;
	public int Size => count * scheme.Size;
	public uint8* Ptr => ptr;

	public BitPackRef this[int i]
	{
		get => .(scheme, ptr + (i*scheme.Size));
		set
		{
			Debug.Assert(value.Scheme == scheme);
			let target = ptr+(i*scheme.Size);
			for(let j < scheme.Size)
			{
				target[j] = value.Ptr[j];
			}	
		}
	}

	public static explicit operator Span<uint8>(Self array) => .(array.Ptr, array.Size);
}