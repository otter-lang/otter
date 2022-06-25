module ast.node_namespace;

// ast/
import ast.node;

// type/*
import type;

// /
import config;
import namespace;
import source_file;
import token;

// standard
import std.conv;
import std.string;

/// A class that represents an Abstract Syntax Tree namespace declaration node.
class NodeNamespace : Node
{
    /// The namespace name.
    Node name;

    /**
        Default Constructor.

        Params:
            name = The namespace name.
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
        // Get namespace name as string.
        string namespace_name = name.emit(file);

        // Check if namespace exists, if not add it.
        if ((namespace_name in g_namespaces) is null)
        {
            g_namespaces[namespace_name] = Namespace
            (
                namespace_name
            );
        }

        // We're inside this namespace.
        file.current_namespace = (&g_namespaces[namespace_name]);
    }

    /**
        Define pass.

        Params:
            file = The file where the node was parsed.
    */
    override void define(ref SourceFile file)
    {
        // We're inside this namespace.
        file.current_namespace = (&g_namespaces[name.emit(file)]);
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        // We're inside this namespace.
        file.current_namespace = (&g_namespaces[name.emit(file)]);
        return null;
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        // Get namespace name.
        string name_string = name.emit(file);

        // Generate a little comment information.
        if (endsWith(file.header, "\n"))
            file.header ~= "\n";

        if (endsWith(file.source, "\n"))
            file.source ~= "\n";

        string information = "/*\n\tnamespace: " ~ name_string ~ "\n*/";

        file.header ~= (information ~ "\n");
        file.source ~= information;

        // We're inside this namespace.
        file.current_namespace = (&g_namespaces[name_string]);
        return null;
    }
}