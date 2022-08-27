module ast.node_declaration;

// ast/*
import ast;

// type/*
import type;

// /
import mod;
import source_file;
import symbol;
import token;

/// A class that represents an Abstract Syntax Tree variable declaration node.
class NodeDeclaration : Node
{
    /// The type of the variable.
    Node type;

    /// The name of the variable.
    Token name;

    /// The value of the variable.
    Node value;

    /**
        Declare pass.

        Params:
            file = The file where the node was parsed.
    */
    override void declare(ref SourceFile file)
    {
        // Check for symbol collision
        if (file.find_symbol(name.content) !is null)
        {
            file.error(name.location, "this symbol was already declared.");
            file.note(file.current_symbol.location, "the symbol is declared here.");
            return;
        }

        // Add symbol to namespace.
        file.mod.symbols[name.content] = Symbol
        (
            SymbolKind.Variable,
            PropertyKind.None,
            file.mod,
            name.content,
            (&file),
            name.location,
        );
    }

    /**
        Define pass.

        Params:
            file = The file where the node was parsed.
    */
    override void define(ref SourceFile file)
    {
        // Get variable symbol.
        Symbol *symbol = file.find_symbol(name.content);

        // Set type to symbol.
        symbol.type = type.check(file);
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        // Check for value type.
        if (value !is null)
        {
            Type value_type = value.check(file);

            if (!value_type.is_identical(type.check(file)))
            {
                file.error(value.start.location, "expression type doesn't match variable type.");
                file.note(type.start.location, "variable type here.");
            }
        }

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
        file.source ~= type.emit(file);
        file.source ~=  file.mangle_name(name.content);

        if (value !is null)
        {
            file.source ~= " = ";
            file.source ~= value.emit(file);
        }
        
        file.source ~= ";\n";
        return null;
    }
}