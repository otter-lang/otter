using System.Text;

public class Emitter
{
	public int        TabCount;
	public SourceFile File;

	private string EmitType(Node node)
	{
		switch (node)
		{
			case NodePrimitiveType primitive:
				return $"{primitive.Type.GetName()}_t";

			default:
				return "<?>";
		}
	}

	private void Emit(NodeFunction node)
	{
		File.Source += $"{EmitType(node.Type)} {node.Name.Content}";
	}

	public void Start()
	{
		foreach (SourceFile file in Globals.SourceFiles)
		{
			TabCount = 0;
			File     = file;
			
			foreach (Node node in file.Nodes)
			{
				switch (node)
				{
					case NodeFunction function:
					{
						Emit(function);
						break;
					}

					default:
						break;
				}
			}
		}
	}
}