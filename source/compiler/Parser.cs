public class Parser
{
	public SourceFile SourceFile;
	public Scanner    Scanner;
	public Token      Previous;
	public Token      Current;

	public Parser()
	{

	}

	private void Note(Token at, string message)
	{
		SourceFile.Diagnostics.Add(new Diagnostic()
		{
			Kind    = DiagnosticKind.Note,
			Message = message,
			Token   = at,
		});
	}

	private void Warning(Token at, string message)
	{
		SourceFile.Diagnostics.Add(new Diagnostic()
		{
			Kind    = DiagnosticKind.Warning,
			Message = message,
			Token   = at,
		});
	}

	private void Error(Token at, string message)
	{
		Console.WriteLine(message);
		SourceFile.Diagnostics.Add(new Diagnostic()
		{
			Kind    = DiagnosticKind.Error,
			Message = message,
			Token   = at,
		});
	}

	private void Advance()
	{
		Previous = Current;

		for (;;)
		{
			Current = Scanner.Next();

			if (Current.Kind != TokenKind.Error)
				break;

			Error(Current, Current.Content);
		}
	}

	private bool Match(TokenKind expected)
	{
		if (Current.Kind == expected)
		{
			Advance();
			return true;
		}

		return false;
	}

	private bool Consume(TokenKind expected, string message)
	{
		if (Match(expected))
			return true;

		Error(Current, message);
		return false;
	}

	private Type ParseType(Token token)
	{
		return new TypePrimitive()
		{
			Kind = (PrimitiveKind)(token.Kind - TokenKind.Void)
		};
	}

	private Node ParseDot(Node left)
	{
		Consume(TokenKind.Identifier, "expected identifier.");
		NodeIdentifier right = new()
		{
			Token = Previous,
		};

		NodeDot node = new()
		{
			Left = left,
			Right = right,
		};

		if (Match(TokenKind.Dot))
			return ParseDot(node);

		return node;
	}

	private Node ParseIdentifier()
	{
		Consume(TokenKind.Identifier, "expected identifier.");
		NodeIdentifier node = new()
		{
			Token = Previous,
		};

		if (Match(TokenKind.Dot))
			return ParseDot(node);

		return node;
	}

	private Node ParseReturnStatement()
	{
		NodeReturn node = new()
		{
			Token = Previous
		};

		// TODO: return value.
		Consume(TokenKind.Semicolon, "expected ';'.");

		return node;
	}

	private Node ParseStatement()
	{
		Advance();

		switch (Previous.Kind)
		{
			// Parse return statement.
			case TokenKind.Return:
				return ParseReturnStatement();

			// Error!
			default:
			{
				Error(Previous, "unexpected token.");
				return null;
			}
		}
	}

	private Node ParseFunctionDeclaration(Node type, Token name)
	{
		NodeFunction node = new()
		{
			Type = type,
			Name = name,
		}; 

		// TODO: function parameters.
		Consume(TokenKind.RightParenthesis, "expected ')' after function parameters.");

		// Parse function body.
		NodeBlock body = new()
		{
			Statements = new()
		};

		Consume(TokenKind.LeftBrace, "expected '{'.");

		if (!Match(TokenKind.RightBrace))
		{
			do
			{
				body.Statements.Add(ParseStatement());
			}
			while (!Match(TokenKind.RightBrace) && !Match(TokenKind.EndOfLine));

			if (Previous.Kind != TokenKind.RightBrace)
				Error(Previous, "expected '}' after function statament(s).");
		}

		node.Body = body;

		return node;
	}

	private Node ParseModuleDeclaration()
	{
		NodeModule node = new();

		// Parse module name.
		node.Name = ParseIdentifier();

		Consume(TokenKind.Semicolon, "expected ';'.");
		return node;
	}

	private void ParseDeclaration()
	{
		Advance();

		switch (Previous.Kind)
		{
			// *Probably* a declaration.
			case >= TokenKind.Void and <= TokenKind.Double:
			{
				// Parse declaration type.
				NodePrimitiveType type = new()
				{
					Type = ParseType(Previous)
				};

				// Parse declaration name.
				Consume(TokenKind.Identifier, "expected declaration name.");
				Token name = Previous;

				// Check for declaration type.
				if (Match(TokenKind.LeftParenthesis))
					SourceFile.Nodes.Add(ParseFunctionDeclaration(type, name));
				else
				{
					// TODO: global variable declaration.
					Consume(TokenKind.Semicolon, "expected ';' after variable name.");
				}

				break;
			}

			// *Maybe* a declaration (user type).
			case TokenKind.Identifier:
			{
				// TODO
				break;
			}

			// Module declaration.
			case TokenKind.Module:
			{
				SourceFile.Nodes.Add(ParseModuleDeclaration());
				break;
			}

			// Error!
			default:
			{
				Error(Previous, "unexpected token.");
				break;
			}
		}
	}

	public void Start()
	{
		// Get global module.
		Module globalModule = Globals.Modules["global"];
		
		// Parse pass.
		foreach (SourceFile sourceFile in Globals.SourceFiles)
		{
			SourceFile = sourceFile;
			Scanner    = sourceFile.Scanner;

			// By default the file's module is "global".
			SourceFile.Module = globalModule;

			Advance();

			while (!Match(TokenKind.EndOfLine))
				ParseDeclaration();
		}

		// Declare pass.
		DeclarePass declarePass = new DeclarePass();
		declarePass.Start();
	}
}