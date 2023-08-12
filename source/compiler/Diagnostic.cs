public enum DiagnosticKind
{
	Note,
	Warning,
	Error,
}

public class Diagnostic
{
	public DiagnosticKind Kind;
	public string         Message;
	public Token          Token;
}