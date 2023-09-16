public enum TokenKind
{
	EndOfLine,
	Error,

	Identifier,
	Integer,
	Float,
	String,

	LeftParenthesis,
	RightParenthesis,
	LeftBrace,
	RightBrace,
	Semicolon,
	Dot,

	True,
	False,
	Null,

	Module,

	Void,
	Bool,
	StringType,

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