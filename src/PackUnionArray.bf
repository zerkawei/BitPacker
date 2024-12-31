using System;
using System.Diagnostics;
namespace BitPacker;

public class PackUnionArray
{
	private PackingScheme[] schemes ~ delete _;
	private int count;
	private int stride;
	private uint8* ptr;

	public this(PackingScheme[] schemes, int count, uint8* ptr)
	{
		this.schemes = schemes;
		this.count  = count;
		this.ptr = ptr;
		this.stride = ComputeStride(schemes);
		
	}

	[AllowAppend]
	public this(PackingScheme[] schemes, int count)
	{
		let stride = ComputeStride(schemes);
		let ptr = append uint8[stride*count]*;

		this.schemes = schemes;
		this.count = count;
		this.ptr = ptr;
		this.stride = stride;
	}

	public PackingScheme[] Schemes => schemes;
	public int Count => count;
	public int Size => count * stride;
	public uint8* Ptr => ptr;

	public BitPackRef this[int i]
	{
		get
		{
			let target = ptr+(i*stride);
			return .(schemes[*target], target+1);
		}
		set
		{
			var target = ptr+(i*stride);

			*target = (.)schemes.IndexOf(value.Scheme);
			target++;
			for(let j < stride-1)
			{
				target[j] = value.Ptr[j];
			}	
		}
	}

	private static int ComputeStride(PackingScheme[] schemes)
	{
		int stride = 0;
		for(let s in schemes)
		{
			if(s.Size > stride) stride = s.Size;
		}
		return ++stride;
	}

	public static explicit operator Span<uint8>(Self array) => .(array.Ptr, array.Size);
}