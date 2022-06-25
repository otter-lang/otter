module ast.node_bool;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

// standard
import std.conv;

/// A class that represents an Abstract Syntax Tree bool literal node.
class NodeBool : Node
{
    /// The bool token.
    Token value;

    /**
        Default Constructor.

        Params:
            value = The bool token.
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
        return new TypePrimitive(PrimitiveKind.Bool);
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