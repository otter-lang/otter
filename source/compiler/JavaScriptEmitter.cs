public class JavaScriptEmitter : Pass
{
	public int TabCount;

	private void Emit(NodeFunction node)
	{
		Console.WriteLine($"function {node.Name.Content}");
	}

	public override void Start()
	{
		TabCount = 0;

		foreach (SourceFile file in Globals.SourceFiles)
		{
			Console.WriteLine($"JavaScript source of [{file.Path}]");
			Console.WriteLine("----------------------");

			foreach (Node _node in file.Nodes)
			{
				switch (_node)
				{
					case NodeFunction node:
					{
						Emit(node);
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