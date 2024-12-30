using BitPacker;
using System;
namespace BitPackerTest;

public enum Foo
{
	A,
	B,
	C
}

public class Program
{
	public static void Main()
	{
		Console.WriteLine("== SIMPLE ==");

		PackingScheme model = scope .(10, 2, 5, 1, 14);
		BitPack instance = scope .(model);

		instance[0] = .Create(1);
		instance[1] = .Create(3);

		Console.WriteLine(instance[0].Get<uint>());
		Console.WriteLine(instance[1].Get<uint>());
		
		Console.WriteLine("== TYPED ==");

		TypedPackingScheme typedModel = scope .(FieldDefintion.Bits(3), .Enum(typeof(Foo)), .IntRange(-1,1), .Bool);
		BitPack tInstance = scope .(typedModel);

		tInstance[0] = .Create(2);
		tInstance[1] = .Create(Foo.C);
		tInstance[2] = .Create(0);
		tInstance[3] = .Create(true);

		Console.WriteLine(tInstance[0].Get<uint>());
		Console.WriteLine(tInstance[1].Get<Foo>());
		Console.WriteLine(tInstance[2].Get<int>());
		Console.WriteLine(tInstance[3].Get<bool>());

		Console.Read();
	}
}