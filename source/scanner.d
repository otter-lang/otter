module scanner;

// /
import file_location;
import token;

/// A structure that represents a scanner.
struct Scanner
{
    /// Points to the start of current token's content.
    const(char) *start;

    /// Points to the end of current token's content.
    const(char) *end;

    /// Points to the start of the line's content.
    const(char) *line_start;

    /// The previous token that was scanned.
    Token previous;

    /// The last token that was scanned.
    Token current;

    /// The current line being scanned.
    uint line;

    /// The current column being scanned.
    uint column;

    /// All the keyword tokens.
    enum TokenKind[string] keywords =
    [
        "true"      : TokenKind.Bool,
        "false"     : TokenKind.Bool,
        "null"      : TokenKind.Null,
        "namespace" : TokenKind.Namespace,
        "using"     : TokenKind.Using,
        "extern"    : TokenKind.Extern,
        "function"  : TokenKind.Function,
        "const"     : TokenKind.Const,
        "return"    : TokenKind.Return,
    ];

    /**
        Constructs a scanner structure.

        Params:
            source = The source file to be scanned.
    */
    this(string source)
    {
        start      = source.ptr;
        end        = source.ptr;
        line_start = source.ptr;
        line       = 1;
        column     = 1;
    }

    /** 
        Is character a digit?

        Params:
            character = The character to check.
    */
    private bool is_digit(char character)
    {
        return (character >= '0' && character <= '9');
    }

    /** 
        Is character a letter or underscore?

        Params:
            character = The character to check.
    */
    private bool is_letter_or_underscore(char character)
    {
        return (character >= 'A' && character <= 'Z') ||
               (character >= 'a' && character <= 'z') ||
               (character == '_');
    }

    /** 
        Advances the current character.

        Returns:
            the previous character that was scanned.
    */
    private char advance()
    {
        // Increase column information.
        ++column;

        // Advance the end pointer.
        ++end;

        // Return the previous character that was scanned.
        return end[-1];
    }

    /**
        Checks if expected character matches current character, if it matches,
        then advance the character.

        Params:
            expected = The expected character to check.
    */
    private bool match(char expected)
    {
        // Check for character and advance if true.
        if ((*end) == expected)
        {
            advance();
            return true;
        }

        // Characters didn't match.
        return false;
    }

    /// Skips whitespace characters (' ', '\r', '\t', '\n'.)
    private void skip_whitespace()
    {
        // Keep skipping whitespace character until it's a valid character.
        for (;;)
        {
            switch (*end)
            {
                // Whitespace.
                case ' ' :
                case '\r':
                case '\t':
                {
                    advance();
                    break;
                }

                // Line.
                case '\n':
                {
                    // Advance the character.
                    ++end;

                    // Increase line information.
                    ++line;

                    // Reset column information.
                    column = 1;

                    // Set line start.
                    line_start = end;
                    break;
                }

                // Comment.
                case '/':
                {
                    // Single line comment?
                    if (end[1] == '/')
                    {
                        while (!match('\n') && !match('\0'))
                            advance();
                        
                        // Increase line information.
                        ++line;

                        // Reset column information.
                        column = 1;

                        // Set line start.
                        line_start = end;
                    }
                    else
                        return;

                    break;
                }

                // Not a whitespace character.
                default:
                    return;
            }
        }
    }

    /**
        Makes token with kind.

        Params:
            kind = The kind of the token.
    */
    private TokenKind make_token(TokenKind kind)
    {
        // Get the length of the token's content it's pointing to.
        uint length = (cast(uint)(end - start));

        // Make token and set it to be the current one.
        current = Token
        (
            kind,
            FileLocation(line_start, line, column, length),
            (cast(string)(start[0 .. length])),
        );

        return kind;
    }
    
    /**
        Makes error token with message.

        Params:
            message = The message of the error token.
    */
    private TokenKind make_token(string message)
    {
        // Get the length of the token's content it's pointing to.
        uint length = (cast(uint)(end - start));

        // Make error token and set it to be the current one.
        current = Token
        (
            TokenKind.Error,
            FileLocation(line_start, line, column, length),
            message,
        );

        return TokenKind.Error;
    }

    /** 
        Makes number token.

        Returns:
            TokenKind.Integer or TokenKind.Float.
    */
    private TokenKind make_number_token()
    {
        // Loop until no digit character.
        while (is_digit(*end))
            advance();

        // Is it a float number?
        if (match('.'))
        {
            // Loop until no digit character.
            while (is_digit(*end))
                advance();

            // Make a float token.
            return make_token(TokenKind.Float);
        }

        // Make an integer token.
        return make_token(TokenKind.Integer);
    }

    /** 
        Makes string token.

        Returns:
            TokenKind.String or TokenKind.Error.
    */
    private TokenKind make_string_token()
    {
        // Loop until we find another '"'.
        while (((*end) != '"') && ((*end) != '\0'))
        {
            // Increase line if needed.
            if ((*end) == '\n')
                ++line;

            advance();
        }

        // Did we scan the string literal correctly? If not, make token error.
        if ((*end) == '\0')
            return make_token("unterminated string.");

        // Advance the '"'.
        advance();

        // Make string token.
        return make_token(TokenKind.String);
    }

    /** 
        Makes identifier token.

        Returns:
            TokenKind.Identifier or the kind of the keyword token.
    */
    private TokenKind make_identifier_token()
    {
        // Loop until no letter or underscore.
        while (is_letter_or_underscore(*end) ||
               is_digit(*end))
            advance();

        // Check for keyword token.
        uint   token_length = (cast(uint  )(end - start));
        string token_value  = (cast(string)(start[0 .. token_length]));

        if (token_value in keywords)
            return make_token(keywords[token_value]);

        // Not a keyword token, make an identifier token.
        return make_token(TokenKind.Identifier);
    }

    /**
        Scans the next token.

        Returns:
            the kind of the last token that was scanned.
    */
    TokenKind next()
    {
        // Try skipping all whitespace characters 
        // before scanning a token.
        skip_whitespace();

        // Set previous token to the current one (if it isn't an error), since
        // we are going to scan a new one.
        if (current.kind != TokenKind.Error)
            previous = current;

        // Advance the start pointer, so it starts pointing to
        // the new token's content.
        start = end;

        // Is the current character a null terminator?
        // (end of file character)
        if ((*end) == '\0')
            return make_token(TokenKind.EndOfFile);

        // Advance the current character and get
        // the previous one.
        char character = advance();

        // Is character a digit?
        if (is_digit(character))
            return make_number_token();
        
        // Is character a letter or underscore?
        if (is_letter_or_underscore(character))
            return make_identifier_token();

        // Check for character and make a token for it.
        switch (character)
        {
            // Left parenthesis character.
            case '(':
                return make_token(TokenKind.LeftParenthesis);

            // Right parenthesis character.
            case ')':
                return make_token(TokenKind.RightParenthesis);

            // Left brace character.
            case '{':
                return make_token(TokenKind.LeftBrace);

            // Right brace character.
            case '}':
                return make_token(TokenKind.RightBrace);

            // Comma character.
            case ',':
                return make_token(TokenKind.Comma);

            // Dot character.
            case '.':
                return make_token(TokenKind.Dot);

            // Colon character.
            case ':':
                return make_token(TokenKind.Colon);

            // Semicolon character.
            case ';':
                return make_token(TokenKind.Semicolon);

            // Star character.
            case '*':
                return make_token(TokenKind.Star);

            // String literal.
            case '"':
                return make_string_token();

            // Unexpected character.
            default:
                return make_token("unexpected character.");
        }
    }
}