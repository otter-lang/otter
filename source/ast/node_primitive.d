module ast.node_primitive;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

// standard
import std.conv;
import std.uni;

/// A class that represents an Abstract Syntax Tree primitive type node.
class NodePrimitive : Node
{
    /// The primitive kind.
    PrimitiveKind kind;

    /**
        Default Constructor.

        Params:
            start = The start token.
            kind  = The primitive kind.
    */
    this(Token start, PrimitiveKind kind)
    {
        this.start = start;
        this.kind  = kind;
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
        return new TypePrimitive(kind);
    }

    /**
        Emit pass.

        Params:
            file   = The file where the node was parsed.
            mangle = Mangle the identifier that will be emitted?
    */
    override string emit(ref SourceFile file, bool mangle = false)
    {
        return (to!(string)(kind)).toLower() ~ "_t ";
    }
}