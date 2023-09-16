using System.Text.RegularExpressions;

public class Scanner
{
	public string Source;
	public int    Start;
	public int    End;
	public int    LineStart;
	public int    Line;
	public int    Column;

	public Dictionary<string, TokenKind> Keywords = new()
	{
		{ "true",   TokenKind.True       },
		{ "false",  TokenKind.False      },
		{ "null",   TokenKind.Null       },

		{ "module", TokenKind.Module     },

		{ "void",   TokenKind.Void       },
		{ "bool",   TokenKind.Bool       },
		{ "string", TokenKind.StringType },

		{ "ubyte",  TokenKind.UByte      },
		{ "ushort", TokenKind.UShort     },
		{ "uint",   TokenKind.UInt       },
		{ "ulong",  TokenKind.ULong      },
		{ "byte",   TokenKind.Byte       },
		{ "short",  TokenKind.Short      },
		{ "int",    TokenKind.Int        },
		{ "long",   TokenKind.Long       },
    
		{ "single", TokenKind.Single     },
		{ "double", TokenKind.Double     },

		{ "return", TokenKind.Return     },
	};

	public Scanner(string source)
	{
		Source    = source;
		Start     = 0;
		End       = 0;
		LineStart = 0;
		Line      = 1;
		Column    = 1;
	}

	private Token Make(TokenKind kind)
	{
		return new Token()
		{
			Kind      = kind, 
			Content   = Source.Substring(Start, End - Start),
			LineStart = LineStart,
			Line      = Line,
			Column    = Column,
		};
	}

	private Token Make(TokenKind kind, string content)
	{
		return new Token()
		{
			Kind      = kind, 
			Content   = content,
			LineStart = LineStart,
			Line      = Line,
			Column    = Column,
		};
	}

	private bool IsEnd()
	{
		return (End >= Source.Length);
	}

	private bool IsIdentifier(char character)
	{
		return (character >= 'A' && character <= 'Z') ||
			   (character >= 'a' && character <= 'z') ||
			   (character == '_' || character == '$');
	}

	private bool IsNumber(char character)
	{
		return (character >= '0' && character <= '9');
	}

	private char GetPrevious()
	{
		if (IsEnd())
			End = Source.Length;

		return Source[End - 1];
	}
	
	private char GetCurrent()
	{
		if (IsEnd())
			End = Source.Length;

		return Source[End];
	}

	private char Advance()
	{
		++End;
		++Column;

		return GetPrevious();
	}

	private void SkipWhitespace()
	{
		while (!IsEnd())
		{
			switch (GetCurrent())
			{
				case ' ':
				case '\t':
				case '\r':
				{
					Advance();
					break;
				}

				case '\n':
				{
					Advance();

					Column     = 1;
					Line      += 1;
					LineStart  = End;

					break;
				}

				default:
					return;
			}
		}
	}

	public Token Next()
	{
		SkipWhitespace();
		Start = End;

		if (IsEnd())
			return Make(TokenKind.EndOfLine);

		char character = Advance();

		if (IsNumber(character))
		{
			while (!IsEnd() && IsNumber(GetCurrent()))
				Advance();

			if (GetCurrent() == '.')
			{
				Advance();

				while (!IsEnd() && IsNumber(GetCurrent()))
					Advance();

				return Make(TokenKind.Float);
			}

			return Make(TokenKind.Integer);
		}

		// if (character == 'u')
		// {
		//     while (!IsEnd() && IsNumber(GetCurrent()))
		//         Advance();

		//     if (IsEnd() || !IsIdentifier(GetCurrent()))
		//         return Make(TokenKind.Unsigned);

		//     if (!IsEnd())
		//         character = GetCurrent();
		// }

		// if (character == 'i')
		// {
		//     while (!IsEnd() && IsNumber(GetCurrent()))
		//         Advance();

		//     if (IsEnd() || !IsIdentifier(GetCurrent()))
		//         return Make(TokenKind.Signed);

		//     if (!IsEnd())
		//         character = GetCurrent();
		// }

		// if (character == 'f')
		// {
		//     while (!IsEnd() && IsNumber(GetCurrent()))
		//         Advance();

		//     if (IsEnd() || !IsIdentifier(GetCurrent()))
		//         return Make(TokenKind.Float);

		//     if (!IsEnd())
		//         character = GetCurrent();
		// }

		if (IsIdentifier(character))
		{
			while (!IsEnd() && (IsIdentifier(GetCurrent()) || IsNumber(GetCurrent())))
				Advance();

			string identifier = Source.Substring(Start, End - Start);

			if (Keywords.ContainsKey(identifier))
				return Make(Keywords[identifier]);

			return Make(TokenKind.Identifier);
		}

		switch (character)
		{
			case '(':
				return Make(TokenKind.LeftParenthesis);

			case ')':
				return Make(TokenKind.RightParenthesis);
				
			case '{':
				return Make(TokenKind.LeftBrace);
				
			case '}':
				return Make(TokenKind.RightBrace);
				
			case ';':
				return Make(TokenKind.Semicolon);

			case '"':
			{
				while (!IsEnd() && (GetCurrent() != '"'))
					Advance();

				if (IsEnd())
					return Make(TokenKind.Error, "unterminated string.");

				Advance(); // "
				return Make(TokenKind.String);
			}

			case '.':
				return Make(TokenKind.Dot);
		}

		return Make(TokenKind.Error, "unexpected character.");
	}
}