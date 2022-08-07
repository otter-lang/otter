module ast.node_identifier;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import symbol;
import token;

/// A class that represents an Abstract Syntax Tree an identifier name node.
class NodeIdentifier : Node
{
    /// The identifier token.
    Token identifier;

    /**
        Default Constructor.

        Params:
            identifier = The identifier token.
    */
    this(Token identifier)
    {
        this.start      = identifier;
        this.identifier = identifier;
    }

    /**
        Declare pass.

        Params:
            file = The file where the node was parsed.
    */
    override void declare(ref SourceFile file)
    {

    }

    /**
        Define pass.

        Params:
            file = The file where the node was parsed.
    */
    override void define(ref SourceFile file)
    {
        
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        Symbol *symbol = file.find_symbol(identifier.content);

        if (symbol !is null)
            return symbol.type;
        else
            file.error(identifier.location, "this symbol doesn't exist.");

        return null;
    }

    /**
        Emit pass.

        Params:
            file   = The file where the node was parsed.
            mangle = Mangle the identifier that will be emitted?
    */
    override string emit(ref SourceFile file, bool mangle = false)
    {
        Symbol *symbol = file.find_symbol(identifier.content);
        string    name = identifier.content;

        return (mangle) ? file.mangle_symbol(symbol)
                        : name;
    }
}