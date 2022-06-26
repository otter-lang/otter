module type.type;

// type/
import type.type_primitive;

/// A class that represents a type.
class Type
{
    /// Is type null?
    bool is_null() 
    {
        return false;
    }
    
    /// Is type void?
    bool is_void() 
    {
        return false;
    }

    /// Is type a primitive, function, pointer...?
    bool is_basic() 
    {
        return false;
    }

    /// Is type an integer?
    bool is_integer() 
    {
        return false;
    }
    
    /// Is type an unsigned integer?
    bool is_unsigned() 
    {
        return false;
    }

    /// Is type a float?
    bool is_float() 
    {
        return false;
    }

    /// Is type a boolean?
    bool is_bool() 
    {
        return false;
    }

    /// Is type constant?
    bool is_const() 
    {
        return false;
    }

    /// Is type a function?
    bool is_function() 
    {
        return false;
    }
    
    /// Is type a pointer?
    bool is_pointer() 
    {
        return false;
    }

    /// Is type a string?
    bool is_string() 
    {
        return false;
    }
    
    /**
        Can type be casted to another type?
    
        Params:
            other = The type to be checked.
    */
    bool can_cast_to(Type other) 
    {
        return false;
    }
    
    /** 
        Is other type identical to this type?
    
        Params:
            other = The type to be checked.
    */
    bool is_identical(Type other) 
    {
        return false;
    }

    /// Get size of the type.
    int get_size()
    {
        return 0;
    }

    /// Get return type from function type.
    Type get_return_type() 
    {
        return null;
    }

    /// Remove the pointer from type.
    Type get_derefed_type() 
    {
        return null;
    }
    
    /// Remove the constant from type.
    Type get_deconsted_type()
    {
        return null;
    }

    /// Get the name of the type.
    string get_name() 
    {
        return null;
    }

    /// Get the kind of primitive type.
    PrimitiveKind get_kind()
    {
        return PrimitiveKind.Null;
    }
}