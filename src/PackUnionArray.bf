using System;
using System.Diagnostics;
using System.Collections;
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

	[AllowAppend]
	public this(List<BitPack> from)
	{
		let schemeList = scope List<PackingScheme>();
		for(let i < from.Count)
		{
			if(!schemeList.Contains(from[i].Scheme))
			{
				schemeList.Add(from[i].Scheme);
			}
		}

		schemes = new .[schemeList.Count];
		schemeList.CopyTo(schemes);
		stride = ComputeStride(schemes);
		count = from.Count;

		let ptr = append uint8[stride*count]*;
		this.ptr = ptr;

		for(let i < from.Count)
		{
			this[i] = .(from[i]);
		}
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

	public void AppendTo(List<BitPack> list)
	{
		for(let i < count)
		{
			list.Add(new .(this[i]));
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