module parser;

// ast/*
import ast;

// type/*
import type;

// /
import file_location;
import namespace;
import source_file;
import scanner;
import config;
import token;

/// A structure that represents a parser.
struct Parser
{
    /// The current source file being parsed.
    SourceFile *file;

    /// The current scanner being used.
    Scanner *scanner;

    /// All the primitive and user types.
    enum PrimitiveKind[string] types =
    [
        "void"   : PrimitiveKind.Void,
        "bool"   : PrimitiveKind.Bool,
        "string" : PrimitiveKind.String,

        "uchar"  : PrimitiveKind.UChar,
        "ubyte"  : PrimitiveKind.UByte,
        "ushort" : PrimitiveKind.UShort,
        "uint"   : PrimitiveKind.UInt,
        "ulong"  : PrimitiveKind.ULong,
        "uword"  : PrimitiveKind.UWord,

        "char"  : PrimitiveKind.Char,
        "byte"  : PrimitiveKind.Byte,
        "short" : PrimitiveKind.Short,
        "int"   : PrimitiveKind.Int,
        "long"  : PrimitiveKind.Long,
        "word"  : PrimitiveKind.Word,

        "single" : PrimitiveKind.Single,
        "double" : PrimitiveKind.Double,
    ];

    /// Advances current token.
    private void advance()
    {
        // Loop until we find a valid token.
        for (;;)
        {
            // Is it a valid token?
            if (scanner.next() != TokenKind.Error)
                break;

            // It's an error token, add diagnostic.
            file.error(scanner.current.location, scanner.current.content);
        }
    }

    /**
        Matches current token kind? If true, advance.

        Params:
            expected = The kind to check.
    */
    bool match(TokenKind expected)
    {
        // Matches?
        if (scanner.current.kind == expected)
        {
            advance();
            return true;
        }

        // Didn't match :c.
        return false;
    }

    /**
        Consume current token if kind matches, else show an error.

        Params:
            expected = The expected token to match.
            message  = The error message if it fails.
    */
    void consume(TokenKind expected, string message)
    {
        // Matches?
        if (match(expected))
            return;

        // Didn't match :p.
        file.error(scanner.current.location, message);
    }

    /// Parse primary expression.
    Node parse_primary()
    {
        // Integer literal.
        if (match(TokenKind.Integer))
            return new NodeInteger(scanner.previous);

        // Float literal.
        if (match(TokenKind.Float))
            return new NodeFloat(scanner.previous);

        // String literal.
        if (match(TokenKind.String))
            return new NodeString(scanner.previous);

        // Bool literal.
        if (match(TokenKind.Bool))
            return new NodeBool(scanner.previous);

        // Null literal.
        if (match(TokenKind.Null))
            return new NodeNull(scanner.previous);

        // Identifier.
        if (match(TokenKind.Identifier))
            return new NodeIdentifier(scanner.previous);

        // Unexpected token.
        file.error(scanner.current.location, "unexpected token.");
        return null;
    }

    /// Parse qualified name.
    Node parse_qualified_name(Node left)
    {
        consume(TokenKind.Identifier, "expected identifier.");
        Node right = new NodeIdentifier(scanner.previous);
        Node name  = new NodeQualified(left, right);

        if (match(TokenKind.Dot))
            return parse_qualified_name(name);

        return name;
    }

    /// Parse identifier name.
    Node parse_name()
    {
        consume(TokenKind.Identifier, "expected identifier.");
        Node left = new NodeIdentifier(scanner.previous);

        if (match(TokenKind.Dot))
            return parse_qualified_name(left);

        return left;
    }

    /// Parse namespace.
    void parse_namespace()
    {
        // Parse namespace name.
        Node name = parse_name();

        // Add namespace "declaration" node to file.
        file.nodes ~= new NodeNamespace(name);

        // Expect semicolon.
        consume(TokenKind.Semicolon, "expected ';'.");
    }

    /// Try parsing a type.
    Node parse_type()
    {
        // Check for token.
        if (match(TokenKind.Const))
        {
            // Get the position of the constant.
            ConstPosition position = ConstPosition.Right;

            if (scanner.current.kind == TokenKind.Star)
                position = ConstPosition.Left;

            Token start = scanner.previous;
            Node  type  = parse_type();

            if (type is null)
                file.error(scanner.previous.location, "expected type after 'const'.");

            return new NodeConst(start, position, type);
        }
        else if (match(TokenKind.Star))
        {
            Token start = scanner.previous;
            Node  type  = parse_type();

            if (type is null)
                file.error(scanner.previous.location, "expected type after '*'.");

            return new NodePointer(start, type);
        }
        else
            advance();

        // Check if type exists.
        Token name = scanner.previous;

        if ((name.content in types) !is null)
        {
            return new NodePrimitive
            (
                name,
                types[name.content]
            );
        }

        // Does not exist.
        return null;
    }

    /// Parse return statement.
    Node parse_return()
    {
        NodeReturn node       = new NodeReturn();
                   node.start = scanner.current;

        // Parse return value.
        node.expression = null;

        if (!match(TokenKind.Semicolon))
        {
            node.expression = parse_primary(); // TODO: expression parsing.

            // Expect semicolon.
            consume(TokenKind.Semicolon, "expected ';'.");
        }

        return node;
    }

     /** 
        Parse call.

        Params:
            expression   = The expression being called.
            is_statement = Is the call a statement?
    */
    Node parse_call(Node expression, bool is_statement)
    {
        NodeCall node              = new NodeCall();
                 node.start        = scanner.previous;
                 node.expression   = expression;
                 node.is_statement = is_statement;

        // Parse call parameters.
        if (!match(TokenKind.RightParenthesis))
        {
            do
            {
                // TODO: parse expression
                node.parameters ~= parse_primary();
            }
            while (match(TokenKind.Comma));

            consume(TokenKind.RightParenthesis, "expected ')' after call parameter(s).");
        }

        // Expect semicolon.
        consume(TokenKind.Semicolon, "expected ';'.");
        return node;
    }

    /// Parse identifier.
    Node parse_identifier()
    {
        Token identifier = scanner.previous;

        // Call?
        if (match(TokenKind.LeftParenthesis))
        {
            return parse_call
            (
                new NodeIdentifier(identifier),
                true
            );
        }

        return null;
    }

    /// Parse statement.
    Node parse_statement()
    {
        // Advance the current token, so it's easier to parse.
        advance();

        // Check for the previous token.
        switch (scanner.previous.kind)
        {
            // Return.
            case TokenKind.Return:
                return parse_return();

            // Identifier.
            case TokenKind.Identifier:
                return parse_identifier();

            // Unexpected token.
            default:
            {
                file.error(scanner.previous.location, "unexpected token.");
                return null;
            }
        }
    }

    /// Parse block of statements.
    Node parse_block()
    {
        NodeBlock node  = new NodeBlock();
        Token     start = scanner.previous;

        // Parse statements until block end.
        while (!match(TokenKind.RightBrace) && !match(TokenKind.EndOfFile))
            node.statements ~= parse_statement();

        // Check if block was parsed correctly.
        if (scanner.previous.kind == TokenKind.EndOfFile)
            file.error(start.location, "expected '}' after block statement(s).");

        return node;
    }

    /// Parse function declaration.
    void parse_function(bool is_extern = false)
    {
        NodeFunction node = new NodeFunction();

        // Parse function name.
        consume(TokenKind.Identifier, "expected function name.");
        node.name = scanner.previous;

        // Parse function parameters.
        consume(TokenKind.LeftParenthesis, "expected '(' after function name.");

        if (!match(TokenKind.RightParenthesis))
        {
            do
            {
                // Parse parameter name.
                consume(TokenKind.Identifier, "expected parameter name.");
                Token parameter_name = scanner.previous;

                // Parse parameter type.
                consume(TokenKind.Colon, "expected ':' after parameter name.");
                Node parameter_type = parse_type();

                if (parameter_type is null)
                    file.error(scanner.previous.location, "expected parameter type after ':'.");

                // Add parameter.
                node.parameters ~= new NodeParameter(parameter_type, parameter_name);
            }
            while (match(TokenKind.Comma));

            // Expect right parenthesis.
            consume(TokenKind.RightParenthesis, "expected ')' after parameter(s).");
        }
        
        // Parse function return type (optional).
        if (match(TokenKind.Colon))
        {
            node.type = parse_type();

            if (node.type is null)
                file.error(scanner.previous.location, "expected function return type after ':'.");
        }
        else
            node.type = new NodePrimitive(scanner.previous, PrimitiveKind.Void);

        // Parse function body (if not extern).
        if (is_extern)
        {
            consume(TokenKind.Semicolon, "expected ';'.");
            node.block = null;
        }
        else
        {
            consume(TokenKind.LeftBrace, "expected '{'.");
            node.block = parse_block();
        }

        // Add node to file.
        file.nodes ~= node;
    }

    /// Parses declarations.
    void parse_declaration()
    {
        // Advance the current token, so it's easier to parse.
        advance();

        // Check for the previous token.
        switch (scanner.previous.kind)
        {
            // Namespace.
            case TokenKind.Namespace:
            {
                parse_namespace();
                break;
            }

            // Extern function declaration.
            case TokenKind.Extern:
            {
                consume(TokenKind.Function, "expected 'function' after 'extern'.");
                parse_function(true);
                break;
            }

            // Function declaration.
            case TokenKind.Function:
            {
                parse_function();
                break;
            }

            // Unexpected token.
            default:
            {
                file.error(scanner.previous.location, "unexpected token.");
                break;
            }
        }
    }

    /// Start parsing the source files.
    void start()
    {
        // Make global namespace.
        g_namespaces["global"] = Namespace("global");

        // Parse every source file.
        foreach (ref SourceFile source; g_source_files)
        {
            // Set current source file.
            file = (&source);

            // Set current scanner.
            scanner = (&source.scanner);

            // Always have a 'namespace global;' at the
            // top of the file, in case there's no namespace specified.
            file.nodes ~= new NodeNamespace
            (
                new NodeIdentifier
                (
                    Token
                    (
                        TokenKind.Identifier,
                        FileLocation(),
                        "global"
                    )
                )
            );

            // Advance the current token, so it's easier to parse.
            advance();

            // Parse declarations until source end.
            while (!match(TokenKind.EndOfFile) && !g_had_fatal_error)
                parse_declaration();

            // Stop if any error happened.
            if (g_had_fatal_error)
                return;
        }

        // Declare every node.
        foreach (ref SourceFile source; g_source_files)
        foreach (ref Node         node; source.nodes)
            node.declare(source);

        // Stop if any error happened.
        if (g_had_fatal_error)
            return;

        // Define every node.
        foreach (ref SourceFile source; g_source_files)
        foreach (ref Node         node; source.nodes)
            node.define(source);

        // Stop if any error happened.
        if (g_had_fatal_error)
            return;

        // Check every node.
        foreach (ref SourceFile source; g_source_files)
        foreach (ref Node         node; source.nodes)
            node.check(source);
    }
}
