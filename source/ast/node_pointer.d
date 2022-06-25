module ast.node_pointer;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

// standard
import std.conv;

/// A class that represents an Abstract Syntax Tree pointer type node.
class NodePointer : Node
{
    /// The start token.
    Token start;

    /// The base type of the pointer.
    Node base;

    /**
        Default Constructor.

        Params:
            start = The start token.
            base  = The base type of the pointer.
    */
    this(Token start, Node base)
    {
        this.start = start;
        this.base  = base;
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
        return new TypePointer(base.check(file));
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        return (base.emit(file) ~ "*");
    }
}