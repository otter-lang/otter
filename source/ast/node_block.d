module ast.node_block;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;

/// A class that represents an Abstract Syntax Tree block of statements node.
class NodeBlock : Node
{
    /// All the statements.
    Node[] statements;

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
        // Check every statement inside the block.
        foreach (ref Node statement; statements)
            statement.check(file);

        return null;
    }

    /**
        Emit pass.

        Params:
            file = The file where the node was parsed.
    */
    override string emit(ref SourceFile file)
    {
        // Emit braces if needed.
        if (statements.length > 1 || file.current_function !is null)
            file.source ~= "{\n";

        // Enter block scope.
        ++file.tabs;

        // Emit a spacing if there's no statement
        // (just so it looks pretty).
        if (statements.length == 0)
            file.source ~= "\t\n";

        // Emit every statement inside the block.
        foreach (ref Node statement; statements)
        {
            // Write the tabs.
            file.write_tabs();

            // Emit the statement.
            statement.emit(file);
        }

        // Leave block scope.
        --file.tabs;

        // Emit braces if needed.
        if (statements.length > 1 || file.current_function !is null)
            file.source ~= "}";

        return null;
    }
}
