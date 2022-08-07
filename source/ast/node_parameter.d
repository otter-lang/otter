module ast.node_parameter;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;
import symbol;

/// A class that represents an Abstract Syntax Tree function parameter node.
class NodeParameter : Node
{
    /// The type of the parameter.
    Node type;

    /// The name of the parameter.
    Token name;

    /**
        Default Constructor.

        Params:
            type = The type of the parameter.
            name = The name of the parameter.
    */
    this(Node type, Token name)
    {
        this.type = type;
        this.name = name;
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
        file.mod.symbols[name.content] =
        Symbol
        (
            SymbolKind.Parameter,
            PropertyKind.None,
            file.mod,
            name.content,
            &file,
            name.location,
            check(file),
        );
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        return type.check(file);
    }

    /**
        Emit pass.

        Params:
            file   = The file where the node was parsed.
            mangle = Mangle the identifier that will be emitted?
    */
    override string emit(ref SourceFile file, bool mangle = false)
    {
        return (type.emit(file) ~ file.mangle_name(name.content));
    }
}
