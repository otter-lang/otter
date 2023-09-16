using System.Reflection.Metadata.Ecma335;
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

	private Symbol GetSymbol(string name)
	{
		// Local module?
		if (File.Module.Symbols.ContainsKey(name))
			return File.Module.Symbols[name];

		// Imported module?
		foreach (Module module in File.Imports)
		{
			if (module.Symbols.ContainsKey(name))
				return module.Symbols[name];
		}

		return null;
	}

	private string MangleName(string name)
	{
		// Check for main function.
		if (name == "main") // TODO: force 'main' to be a function. 
			return "main";

		// Get symbol.
		Symbol symbol = GetSymbol(name);

		if (symbol == null) // TODO: improve this.
			return "<internal error>";

		// Mangle symbol.
		return $"{symbol.Module.Name.Replace(".", "_")}_{name}";
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

	private void EmitExpression(Node node)
	{
		switch (node)
		{
			case NodeNull:
			{
				File.Source += "nullptr";
				break;
			}

			default:
			{
				File.Source += node.Token.Content;
				break;
			}
		}
	}

	private void EmitReturn(NodeReturn node)
	{
		File.Source += "return";

		if (node.Value != null)
		{
			File.Source += ' ';
			EmitExpression(node.Value);			
		}

		File.Source += ";\n";
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
		// Mangle function name.
		string functionName = MangleName(node.Name.Content);

		// Formatting: avoid having a newline after a #include.
		if (!EmittedFunction)
			EmittedFunction = true;
		else
		{
			File.Header += '\n';
			File.Source += '\n';
		}

		// Write function declaration.
		File.Header += $"extern {TypeToString(node.Type)} {functionName}();\n";

		// Write function definition.
		// TODO: function parameters.	
		File.Source += $"{TypeToString(node.Type)} {functionName}()";

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

			File.Module = Globals.Modules["global"];
			
			foreach (Node node in file.Nodes)
			{
				switch (node)
				{
					case NodeModule module:
					{
						File.Module = Globals.Modules[module.Name.GetString()];
						break;
					}

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