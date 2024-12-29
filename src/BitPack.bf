using System;
namespace BitPacker;

public class BitPack
{
	private PackingScheme scheme;
	private uint8* bytes;

	public this(PackingScheme scheme, uint8* bytes)
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

	public PackingScheme Scheme => scheme;
	public Span<uint8> Bytes => .(bytes, scheme.Size);

	public Variant this[int field]
	{
		get => scheme.Get(Bytes, field);
		set => scheme.Set(Bytes, field, value);
	}
}