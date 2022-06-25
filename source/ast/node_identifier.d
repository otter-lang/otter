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
        return null;
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        return identifier.content;
    }
}