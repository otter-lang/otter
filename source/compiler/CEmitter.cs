using System.Text;

public class CEmitter : Pass
{
	public int           TabCount;
	public SourceFile    File;
	public StringBuilder Header;
	public StringBuilder Source;


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
		Source.Append($"{EmitType(node.Type)} {node.Name.Content}");
	}

	public override void Start()
	{
		foreach (SourceFile file in Globals.SourceFiles)
		{
			TabCount = 0;

			File = file;
			
			file.Results.Add(new());
			Header = file.Results[0];

			file.Results.Add(new());
			Source = file.Results[1];

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