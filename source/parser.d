module parser;

// ast/*
import ast;

// type/*
import type;

// /
import file_location;
import mod;
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
        {
            Node node = new NodeIdentifier(scanner.previous);

            if (match(TokenKind.LeftParenthesis))
                return parse_call(node, false);
            else
                return node;
        }

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

    /// Parse module declaration.
    void parse_module()
    {
        // Parse module name.
        Node name = parse_name();

        // Add module "declaration" node to file.
        file.nodes ~= new NodeModule(name);

        // Expect semicolon.
        consume(TokenKind.Semicolon, "expected ';'.");
    }

    /// Parse import statement.
    void parse_import()
    {
        // Parse module name.
        Node name = parse_name();

        // Add import statement node to file.
        file.nodes ~= new NodeImport(name);

        // Expect semicolon.
        consume(TokenKind.Semicolon, "expected ';'.");
    }

    /// Try parsing a type.
    Node parse_type()
    {
        Node node = null;

        // Check for constant identifier.
        if (match(TokenKind.Const))
            node = new NodeConst(scanner.previous, ConstPosition.Left, null);
    
        // Check if type exists.
        advance();
        Token name = scanner.previous;

        if ((name.content in types) !is null)
        {
            Node primitive = new NodePrimitive
            (
                name,
                types[name.content]
            );

            // Check for constant type.
            if (node !is null)
            {
                NodeConst const_node      = cast(NodeConst)node;
                          const_node.type = primitive;
            }
            else
                node = primitive;
        }

        // Failed to parse type.
        if (node is null)
            file.error(name.location, "expected type.");
        else
        {
            // Check for pointer type.
            while (match(TokenKind.Star))
                node = new NodePointer(scanner.previous, node);

            // Check for constant pointer.
            if (match(TokenKind.Const))
                node = new NodeConst(scanner.previous, ConstPosition.Right, node);
        }

        return node;
    }

    /// Try parsing a type.
    Node parse_type(Token token)
    {
        Node node = null;

        // Check for constant identifier.
        if (token.kind == TokenKind.Const)
        {
            node = new NodeConst(scanner.previous, ConstPosition.Left, null);
            
            advance();
            token = scanner.previous;
        }
    
        // Check if type exists.
        Token name = token;

        if ((name.content in types) !is null)
        {
            Node primitive = new NodePrimitive
            (
                name,
                types[name.content]
            );

            // Check for constant type.
            if (node !is null)
            {
                NodeConst const_node      = cast(NodeConst)node;
                          const_node.type = primitive;
            }
            else
                node = primitive;
        }

        // Failed to parse type.
        if (node is null)
            file.error(name.location, "expected type.");
        else
        {
            // Check for pointer type.
            while (match(TokenKind.Star))
                node = new NodePointer(scanner.previous, node);

            // Check for constant pointer.
            if (match(TokenKind.Const))
                node = new NodeConst(scanner.previous, ConstPosition.Right, node);
        }

        return node;
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
        if (is_statement)
            consume(TokenKind.Semicolon, "expected ';'.");

        return node;
    }

    /// Parse variable declaration.
    Node parse_variable_declaration(Node type)
    {
        NodeDeclaration node      = new NodeDeclaration();
                        node.type = type;

        // Parse variable name.
        consume(TokenKind.Identifier, "expected variable name after type.");
        node.name = scanner.previous;

        // Parse variable value.
        if (match(TokenKind.Equal))
            node.value = parse_primary();
        else
            node.value = null;

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

        // Declaration?
        else
        {
            Node type = parse_type(identifier);

            if (type !is null)
                return parse_variable_declaration(type);
            else
                file.error(identifier.location, "unexpected token.");
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

    /// Parse extern function declaration.
    Node parse_extern_function()
    {
        NodeFunction node = new NodeFunction();

        // Parse function return type.
        Node type = parse_type();

        if (type is null)
            file.error(scanner.previous.location, "expected extern function type.");

        node.type = type;

        // Parse function name.
        consume(TokenKind.Identifier, "expected extern function name after type.");
        node.name = scanner.previous;

        // Parse function parameters.
        consume(TokenKind.LeftParenthesis, "expected '(' after function name.");

        if (!match(TokenKind.RightParenthesis))
        {
            do
            {
                // Parse parameter type.
                Node parameter_type = parse_type();

                if (parameter_type is null)
                    file.error(scanner.previous.location, "expected parameter type.");

                // Parse parameter name.
                consume(TokenKind.Identifier, "expected parameter name after type.");
                Token parameter_name = scanner.previous;
                
                // Add parameter.
                node.parameters ~= new NodeParameter(parameter_type, parameter_name);
            }
            while (match(TokenKind.Comma));

            // Expect right parenthesis.
            consume(TokenKind.RightParenthesis, "expected ')' after parameter(s).");
        }

        consume(TokenKind.Semicolon, "expected ';'.");
        return node;
    }

    /// Parse function declaration.
    Node parse_function(Node type, Token name)
    {
        NodeFunction node = new NodeFunction();

        // Parse function name.
        node.type = type;
        node.name = name;

        // Parse function parameters.
        if (!match(TokenKind.RightParenthesis))
        {
            do
            {
                // Parse parameter type.
                Node parameter_type = parse_type();

                if (parameter_type is null)
                    file.error(scanner.previous.location, "expected parameter type.");

                // Parse parameter name.
                consume(TokenKind.Identifier, "expected parameter name after type.");
                Token parameter_name = scanner.previous;
                
                // Add parameter.
                node.parameters ~= new NodeParameter(parameter_type, parameter_name);
            }
            while (match(TokenKind.Comma));

            // Expect right parenthesis.
            consume(TokenKind.RightParenthesis, "expected ')' after parameter(s).");
        }

        // Parse function body.
        if (match(TokenKind.LeftBrace))
            node.block = parse_block();
        else if (match(TokenKind.Arrow))
        {
            NodeReturn return_node            = new NodeReturn();
                       return_node.start      = scanner.current;
                       return_node.expression = parse_primary(); // TODO: expression parsing

            NodeBlock block_node             = new NodeBlock();
                      block_node.statements ~= return_node;

            node.block = block_node;
            consume(TokenKind.Semicolon, "expected ';'.");
        }
        else
            file.error(scanner.current.location, "expected '{' or '=>'.");

        return node;
    }

    /** 
         Try parsing a declaration.

        Params:
            type = The type of the declaration.
    */
    Node parse_declaration(Node type)
    {
        // Get declaration name.
        consume(TokenKind.Identifier, "expected declaration name.");
        Token name = scanner.previous;

        // Is it a function?
        if (match(TokenKind.LeftParenthesis))
            return parse_function(type, name);
        else
        {
            file.error(scanner.current.location, "expected function declaration.");
            return null;
        }
    }

    /// Parses declarations.
    void parse_declaration()
    {
        // Advance the current token, so it's easier to parse.
        advance();

        // Check for the previous token.
        switch (scanner.previous.kind)
        {
            // Module declaration.
            case TokenKind.Module:
            {
                parse_module();
                break;
            }

            // Import statement.
            case TokenKind.Import:
            {
                parse_import();
                break;
            }

            // Extern function declaration.
            case TokenKind.Extern:
            {
                file.nodes ~= parse_extern_function();
                break;
            }

            // Try parsing declaration.
            default:
            {
                Node type = parse_type(scanner.previous);

                if (type !is null)
                    file.nodes ~= parse_declaration(type);
                else
                    file.error(scanner.previous.location, "unexpected token.");

                break;
            }
        }
    }

    /// Start parsing the source files.
    void start()
    {
        // Make global namespace.
        g_modules["global"] = Module("global");

        // Parse every source file.
        foreach (ref SourceFile source; g_source_files)
        {
            // Set current source file.
            file = (&source);

            // Set current scanner.
            scanner = (&source.scanner);

            // Always have a 'namespace global;' at the
            // top of the file, in case there's no namespace specified.
            file.nodes ~= new NodeModule
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
