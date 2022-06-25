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

    /// The position of the constant.
    /// NOTE: const* = a constant pointer.
    ///       *const = a pointer to a constant.
    ConstPosition position;

    /// The type that is constant.
    Node type;

    /**
        Default Constructor.

        Params:
            start    = The start token.
            position = The position of the constant.
            type     = The type to be constant.
    */
    this(Token start, ConstPosition position, Node type)
    {
        this.start    = start;
        this.position = position;
        this.type     = type;
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
        return new TypeConst(type.check(file), position);
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        if (position == ConstPosition.Right)
            return ("const " ~ type.emit(file));
        else
            return (type.emit(file) ~ "const ");
    }
}