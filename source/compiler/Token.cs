public enum TokenKind
{
	EndOfLine,
	Error,

	Identifier,
	Number,

	LeftParenthesis,
	RightParenthesis,
	LeftBrace,
	RightBrace,
	Semicolon,
	Dot,

	Module,

	Void,
	Bool,
	String,

	UByte,
	UShort,
	UInt,
	ULong,
	Byte,
	Short,
	Int,
	Long,

	Single,
	Double,

	Return,
}

public class Token
{
	public TokenKind Kind;
	public string    Content;
	public int       LineStart;
	public int       Line;
	public int       Column;
}