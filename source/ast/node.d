module ast.node;

// type/*
import type;

// /
import source_file;

/// A class that represents an Abstract Syntax Tree node.
class Node
{
    /**
        Declare pass.

        Params:
            file = The file where the node was parsed.
    */
    void declare(ref SourceFile file)
    {

    }

    /**
        Define pass.

        Params:
            file = The file where the node was parsed.
    */
    void define(ref SourceFile file)
    {
        
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    Type check(ref SourceFile file)
    {
        return null;
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    string emit(ref SourceFile file)
    {
        return null;
    }
}