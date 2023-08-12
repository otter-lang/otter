using System.Text;

public class Emitter
{
	public int        TabCount;
	public SourceFile File;

	private bool EmittedFunction;

	private string TabToString()
	{
		string result = "";

		for (int i = 0; i < TabCount; ++i)
			result += '\t';

		return result;
	}

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

	private void EmitReturn(NodeReturn node)
	{
		File.Source += "return;\n";
	}

	private void EmitStatement(Node node)
	{
		switch (node)
		{
			case NodeReturn _return:
			{
				EmitReturn(_return);
				break;
			}
		}
	}

	private void Emit(NodeFunction node)
	{
		// Formatting: avoid having a newline after a #include.
		if (!EmittedFunction)
			EmittedFunction = true;
		else
		{
			File.Header += '\n';
			File.Source += '\n';
		}

		// Write function declaration.
		File.Header += $"extern {TypeToString(node.Type)} {node.Name.Content}();\n";

		// Write function definition.
		// TODO: function parameters.	
		File.Source += $"{TypeToString(node.Type)} {node.Name.Content}()";

		// Write function body.
		++TabCount;
		File.Source += "\n{\n";

		switch (node.Body)
		{
			case NodeBlock block:
			{	
				foreach (Node statement in block.Statements)
				{
					File.Source += TabToString();
					EmitStatement(statement);
				}

				break;
			}

			default:
			{
				File.Source += TabToString();
				EmitStatement(node.Body);
				break;
			}
		}

		File.Source += "}\n";
		--TabCount;
	}

	public void Start()
	{
		foreach (SourceFile file in Globals.SourceFiles)
		{
			TabCount        = 0;
			File            = file;
			EmittedFunction = false;
			
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