module ast.node;

// type/*
import type;

// /
import source_file;
import token;

/// A class that represents an Abstract Syntax Tree node.
class Node
{    
    /// The start token.
    Token start;
    
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
            file   = The file where the node was parsed.
            mangle = Mangle the identifier that will be emitted?
    */
    string emit(ref SourceFile file, bool mangle = false)
    {
        return null;
    }
}