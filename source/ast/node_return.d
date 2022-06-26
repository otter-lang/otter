module ast.node_return;

// ast/
import ast.node;

// type/*
import type;

// /
import source_file;
import token;

/// A class that represents an Abstract Syntax Tree return statement node.
class NodeReturn : Node
{
    /// The return value.
    Node expression;

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
        // Get expression type.
        Type expression_type = (expression is null) ? new TypePrimitive(PrimitiveKind.Void) :
                                                      expression.check(file);

        // Get function return type.
        Type return_type = file.current_function.type.get_return_type();

        // Check for function return type and expression type.
        if (!return_type.is_identical(expression_type))
        {
            file.error(start.location, "return value type don't match function return type.");
            file.note(file.current_function.location, "the function declaration is here.");
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
        // Emit "return".
        file.source ~= "return";

        // Check for value
        if (expression !is null)
            file.source ~= (" " ~ expression.emit(file) ~ ";\n"); // emit " <expression>;\n".
        else
            file.source ~= ";\n"; // emit ";\n".

        return null;
    }
}