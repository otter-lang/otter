public class Dumper : Pass
{
	public int TabCount;

	private string EmitType(Node node)
	{
		switch (node)
		{
			case NodePrimitiveType primitive:
				return primitive.Type.GetName();

			default:
				return "<?>";
		}
	}

	private void Emit(NodeFunction node)
	{
		Console.WriteLine($"{EmitType(node.Type)} {node.Name.Content}");
	}

	private void Emit(NodeModule node)
	{
		Console.WriteLine($"module {node.Name.GetString()};\n");
	}

	public override void Start()
	{
		TabCount = 0;

		foreach (SourceFile file in Globals.SourceFiles)
		{
			Console.WriteLine($"dump of [{file.Path}]");
			Console.WriteLine("----------------------");

			foreach (Node node in file.Nodes)
			{
				switch (node)
				{
					case NodeFunction function:
					{
						Emit(function);
						break;
					}

					case NodeModule module:
					{
						Emit(module);
						break;
					}

					default:
						break;
				}
			}
			
			Console.WriteLine("----------------------");
		}
	}
}