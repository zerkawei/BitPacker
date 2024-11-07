using BitPacker;
using System;
namespace BitPackerTest;

public class Program
{
	public static void Main()
	{
		BitPosition[] sizes = new .(.(10),.(2),.(5),.(1),.(14));
				
		BitPackedType model = scope .(sizes, => BitPacker.DefaultPacker);
		uint8[] instance = scope .[model.Size];

		model.Set(instance, 0, 1);
		model.Set(instance, 1, 3);

		Console.WriteLine(model.Get<uint16>(instance, 0));
		Console.WriteLine(model.Get<uint8>(instance, 1));

		Console.WriteLine(instance[0]);
		Console.Read();
	}
}