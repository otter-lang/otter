module token;

// /
import file_location;

/// The kind of a token.
enum TokenKind : uint
{
    /// This should never be used, here only because
    /// default initialization.
    None,

    /// End of file character '\0'.
    EndOfFile,

    /// An error message.
    Error,

    /// An identifier (can be any ASCII letter, '$' and '_').
    Identifier,

    /// An integer (can be any number).
    Integer,

    /// A float (can be any number).
    Float,

    /// A string (can be anything inside double quotes ('"')).
    String,

    /// A bool ('true' or 'false').
    Bool,

    /// A null ('null').
    Null,

    /// Left parenthesis character '('.
    LeftParenthesis,

    /// Right parenthesis character ')'.
    RightParenthesis,

    /// Left brace character '{'.
    LeftBrace,

    /// Right brace character '}'.
    RightBrace,

    /// Comma character ','.
    Comma,

    /// Dot character '.'.
    Dot,
    
    /// Colon character ':'.
    Colon,

    /// Semicolon character ';'.
    Semicolon,

    /// Star character '*'.
    Star,

    /// Module keyword 'module'.
    Module,

    /// Import keyword 'import'.
    Import,

    /// Extern keyword 'extern'.
    Extern,

    /// Function keyword 'function'.
    Function,

    /// Const keyword 'const'.
    Const,

    /// Return keyword 'return'.
    Return,
}

/// A structure that represents a scanner's token.
struct Token
{
    /// The kind of the token.
    TokenKind kind;

    /// The location of the token in the file.
    FileLocation location;

    /// The content of the token.
    string content;
}