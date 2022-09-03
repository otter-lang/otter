module ast.node_module;

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

/// A class that represents an Abstract Syntax Tree module declaration node.
class NodeModule : Node
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
        this.name  = name;
    }

    /**
        Declare pass.

        Params:
            file = The file where the node was parsed.
    */
    override void declare(ref SourceFile file)
    {
        // Get module name as string.
        string module_name = name.emit(file);

        // Check if module exists, if not add it.
        if ((module_name in g_modules) is null)
        {
            g_modules[module_name] = Module
            (
                module_name
            );
        }

        // We're inside this module.
        g_modules[module_name].files ~= file;
        file.mod = (&g_modules[module_name]);
    }

    /**
        Define pass.

        Params:
            file = The file where the node was parsed.
    */
    override void define(ref SourceFile file)
    {
        // We're inside this module.
        file.mod = (&g_modules[name.emit(file)]);
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        // We're inside this module.
        file.mod = (&g_modules[name.emit(file)]);
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
        // We're inside this module.
        file.mod = (&g_modules[name.emit(file)]);
        return null;
    }
}