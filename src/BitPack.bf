using System;
namespace BitPacker;

public class BitPack
{
	private PackingScheme scheme;
	private uint8* bytes;

	public this(uint8* bytes, PackingScheme scheme)
	{
		this.scheme = scheme;
		this.bytes = bytes;
	}

	[AllowAppend]
	public this(PackingScheme scheme)
	{
		let bytes = append uint8[scheme.Size]*;
		
		this.scheme = scheme;
		this.bytes = bytes;
	}

	[AllowAppend]
	public this(PackingScheme scheme, params Object[] values) : this(scheme)
	{
		for(let i < values.Count)
		{
			this[i] = .CreateFromBoxed(values[i]);
		}
	}

	public uint8* Ptr => bytes;
	public PackingScheme Scheme => scheme;

	public Variant this[int field]
	{
		get => scheme.Get(bytes, field);
		set => scheme.Set(bytes, field, value);
	}
}