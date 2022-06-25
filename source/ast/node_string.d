module ast.node_string;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

/// A class that represents an Abstract Syntax Tree string literal node.
class NodeString : Node
{
    /// The string token.
    Token value;

    /**
        Default Constructor.

        Params:
            value = The string token.
    */
    this(Token value)
    {
        this.value = value;
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
        return new TypePrimitive(PrimitiveKind.String);
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        return value.content;
    }
}