module ast.node_function;

// ast/*
import ast;

// type/*
import type;

// /
import namespace;
import source_file;
import symbol;
import token;

/// A class that represents an Abstract Syntax Tree function declaration node.
class NodeFunction : Node
{
    /// The return type of the function.
    Node type;

    /// The name of the function.
    Token name;

    /// The parameters of the function.
    Node[] parameters;

    /// The body of the function.
    /// NOTE: It's always a NodeBlock.
    Node block;

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
        file.current_namespace.symbols[name.content] = Symbol
        (
            SymbolKind.Function,
            (block is null) ? PropertyKind.Extern : 
                              PropertyKind.None,
            file.current_namespace,
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
        // Get function symbol.
        Symbol *symbol = file.find_symbol(name.content);

        // Make function type.
        TypeFunction function_type = new TypeFunction();

        // Add return type.
        function_type.type = type.check(file);

        // Add parameter types.
        foreach (ref Node parameter; parameters)
            function_type.parameters ~= parameter.check(file);

        // Set type to symbol.
        symbol.type = function_type;
    }

    /**
        Check pass.

        Params:
            file = The file where the node was parsed.
    */
    override Type check(ref SourceFile file)
    {
        // We're checking this function.
        file.current_function = file.find_symbol(name.content);

        // Check the function body (block).
        if (block !is null)
            block.check(file);

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
        // We're emitting this function.
        file.current_function = file.find_symbol(name.content);

        // Generate function head.
        string function_type = type.emit(file);

        // NOTE: if it's the entry point function, 
        // then generate int type.
        if (file.current_namespace.name == "main" &&
            name.content                == "main")
            function_type = "int ";

        string function_head  = function_type;
               function_head ~= file.mangle_name(name.content);
               function_head ~= "(";

        foreach (ulong index, ref Node parameter; parameters)
        {
            function_head ~= parameter.emit(file);

            if (index != (cast(int)parameters.length - 1))
                function_head ~= ", ";
        }

        function_head ~= ")";

        // Emit declaration in header.
        string extern_string = (block is null) ? "extern \"C\" "
                                               : "extern ";

        file.header ~= extern_string ~ function_head ~ ";\n";

        // Emit source (if not extern).
        if (block !is null)
        {
            // Emit head in source.
            file.source ~= "\n" ~ function_head ~ "\n";

            // Emit the function body (block).
            if (block !is null)
                block.emit(file);

            file.source ~= "\n";
        }

        // We're no longer emitting this function.
        file.current_function = null;

        return null;
    }
}