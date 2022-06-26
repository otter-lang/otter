module ast.node_qualified;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import symbol;
import token;

/// A class that represents an Abstract Syntax Tree a qualified name node.
class NodeQualified : Node
{
    /// The left name node.
    Node left;

    /// The right name node.
    Node right;

    /**
        Default Constructor.

        Params:
            left  = The left name node.
            right = The right name node.
    */
    this(Node left, Node right)
    {
        this.left  = left;
        this.right = right;
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
        Symbol *symbol = file.find_symbol(emit(file));

        if (symbol !is null)
            return symbol.type;

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
        string name = (left.emit(file) ~ "." ~ right.emit(file));

        return (mangle) ? file.mangle_name(name)
                        : name;
    }
}