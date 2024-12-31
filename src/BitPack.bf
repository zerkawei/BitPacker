using System;
namespace BitPacker;

public class BitPack
{
	private PackingScheme scheme;

	[AllowAppend]
	public this(PackingScheme scheme)
	{
		let ptr = append uint8[scheme.Size]*;
		this.scheme = scheme;
	}

	[AllowAppend]
	public this(PackingScheme scheme, params Object[] values) : this(scheme)
	{
		for(let i < values.Count)
		{
			this[i] = .CreateFromBoxed(values[i]);
		}
	}

	[AllowAppend]
	public this(BitPackRef from)
	{
		let ptr = append uint8[from.Scheme.Size]*;
		this.scheme = from.Scheme;
		
		for(let i < from.Scheme.Size)
		{
			ptr[i] = from.Ptr[i];
		}
	}

	public uint8* Ptr => (.)(&scheme + 1);
	public PackingScheme Scheme => scheme;

	public Variant this[int field]
	{
		get => scheme.Get(Ptr, field);
		set => scheme.Set(Ptr, field, value);
	}
}

public struct BitPackRef
{
	private PackingScheme scheme;
	private uint8* ptr;

	public this(PackingScheme scheme, uint8* ptr)
	{
		this.scheme = scheme;
		this.ptr = ptr;
	}

	public this(BitPack pack)
	{
		this.scheme = pack.Scheme;
		this.ptr    = pack.Ptr;
	}

	public uint8* Ptr => ptr;
	public PackingScheme Scheme => scheme;

	public Variant this[int field]
	{
		get => scheme.Get(ptr, field);
		set => scheme.Set(ptr, field, value);
	}

	public static explicit operator Span<uint8>(Self x) => .(x.Ptr, x.Scheme.Size);
}