using BitPacker;
using System;
namespace BitPackerTest;

public class Program
{
	public static void Main()
	{
		PackingScheme model = scope .(10, 2, 5, 1, 14);
		BitPack instance = scope .(model);

		instance[0] = .Create(1);
		instance[1] = .Create(3);

		Console.WriteLine(instance[0].Get<uint>());
		Console.WriteLine(instance[1].Get<uint>());

		Console.Read();
	}
}