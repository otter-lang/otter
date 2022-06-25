module ast.node_const;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

// standard
import std.conv;

/// A class that represents an Abstract Syntax Tree constant type node.
class NodeConst : Node
{
    /// The start token.
    Token start;

    /// The type that is constant.
    Node type;

    /**
        Default Constructor.

        Params:
            start = The start token.
            type  = The type to be constant.
    */
    this(Token start, Node type)
    {
        this.start = start;
        this.type  = type;
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
        return new TypeConst(type.check(file));
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        return ("const " ~ type.emit(file));
    }
}