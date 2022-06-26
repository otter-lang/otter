module type.type_function;

// type/
import type.type;

/// A class that represents a function type.
class TypeFunction : Type
{
    /// The return type of the function.
    Type type;

    /// The parameters types of the function.
    Type[] parameters;

    /// Is type a function?
    override bool is_function() 
    {
        return true;
    }
    
    /** 
        Is other type identical to this type?
    
        Params:
            other = The type to be checked.
    */
    override bool is_identical(Type other) 
    {
        // Make sure other type is a function.
        if (!other.is_function())
            return false;

        // Get return type and check parameters
        // types.
        Type return_type = other.get_return_type();

        // Check return types.
        if (return_type !is null)
            return type.is_identical(return_type);
        else
            return false;
    }

    /** 
        Get return type from function type only and check parameters types.
    
        Params:
            parameters = The parameters to be checked.
    */
    override Type get_return_type() 
    {
        return type;
    }

    /// Get the name of the type.
    override string get_name() 
    {
        string name = "function(";

        for (uint index = 0; index < parameters.length; ++index)
        {
            name ~= parameters[index].get_name();

            if (index != (cast(int)parameters.length - 1))
                name ~= ", ";
        }

        name ~= "): " ~ type.get_name();
        return name;
    }
}