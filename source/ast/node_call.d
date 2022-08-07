module ast.node_call;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import symbol;
import token;

/// A class that represents an Abstract Syntax Tree call statement/
/// expression node.
class NodeCall : Node
{
    /// The expression being called.
    Node expression;

    /// The parameters of the call.
    Node[] parameters;

    /// Is call a statement?
    bool is_statement;

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
        // Get expression's type.
        TypeFunction type = (cast(TypeFunction)expression.check(file));

        // Check for expression.
        if (type is null)
        {
            file.error(expression.start.location, "this symbol doesn't exist.");
            return null;
        }

        // Check for expression's type.
        if (!type.is_function())
            file.error(start.location, "calling a non-function symbol.");
        else
        {
            // Check for parameter count.
            if (type.parameters.length != parameters.length)
            {
                file.error(start.location, "function call parameter count don't match function parameter count.");
                file.note(file.current_symbol.location, "the function declaration is here.");
            }
            else
            {
                // Check for parameter types.
                foreach (ulong index, ref Type parameter; type.parameters)
                {
                    // Get call's parameter at index.
                    Type call_parameter = parameters[index].check(file);

                    // Compare types.
                    if (!parameter.is_identical(call_parameter))
                    {
                        file.error(parameters[index].start.location, 
                            "expected '" ~ parameter.get_name()      ~ "', got '" 
                                         ~ call_parameter.get_name() ~ "'.");
                    }
                }
            }

            return type.get_return_type();
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
        file.source ~= expression.emit(file, true);
        file.source ~= '(';

        foreach (ulong index, ref Node parameter; parameters)
        {
            file.source ~= parameter.emit(file, true);

            if (index != (cast(int)parameters.length - 1))
                file.source ~= ", ";
        }

        file.source ~= ')';

        if (is_statement)
            file.source ~= ";\n";

        return null;
    }
}