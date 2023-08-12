using System.Text;

public class Emitter
{
	public int        TabCount;
	public SourceFile File;

	private string PrimitiveKindToString(PrimitiveKind kind)
	{
		string result = "";

		if (kind >= PrimitiveKind.UByte && kind <=PrimitiveKind.ULong)
			result += "unsigned ";

		switch (kind)
		{
			case PrimitiveKind.UByte:
			case PrimitiveKind.Byte:
			{
				result += "char";
				break;
			}

			case PrimitiveKind.ULong:
			case PrimitiveKind.Long:
			{	
				result += "long long";
				break;
			}

			case PrimitiveKind.Single:
			{
				result += "float";
				break;
			}

			default:
			{
				result += kind.ToString().ToLower();
				break;
			}
		}

		return result;
	}

	private string TypeToString(Node node)
	{
		switch (node)
		{
			case NodePrimitiveType primitive:
				return PrimitiveKindToString(primitive.Type.GetKind());

			default:
				return "<?>";
		}
	}

	private void Emit(NodeFunction node)
	{
		File.Source += $"{TypeToString(node.Type)} {node.Name.Content}";
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