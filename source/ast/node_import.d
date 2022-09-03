module ast.node_import;

// ast/
import ast.node;

// type/*
import type;

// /
import config;
import mod;
import source_file;
import token;

// standard
import std.conv;
import std.string;

/// A class that represents an Abstract Syntax Tree import statement node.
class NodeImport : Node
{
    /// The module name.
    Node name;

    /**
        Default Constructor.

        Params:
            name = The module name.
    */
    this(Node name)
    {
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
        // Get module name as string.
        string name_string = name.emit(file);

        // Make sure module exists
        if ((name_string in g_modules) is null)
        {
            file.error(name.start.location, "this module doesn't exist.");
            return;
        }

        // Add module to file imports.
        file.imports ~= &(g_modules[name_string]);
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
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
        return null;
    }
}