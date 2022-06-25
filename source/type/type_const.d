module type.type_const;

// type/
import type.type;

/// The position of the constant in a type.
enum ConstPosition 
{
    Left,
    Right,
}

/// A class that represents a constant type.
class TypeConst : Type
{
    /// The type that is constant.
    Type type;

    /// The position of the constant.
    ConstPosition position;

    /** 
        Default Constructor.

        Params:
            type     = The type to be constant.
            position = The position of the constant.
    */
    this(Type type, ConstPosition position)
    {
        this.type     = type;
        this.position = position;
    }
    
    /// Is type void?
    override bool is_void() 
    {
        return (type.is_void());
    }

    /// Is type a primitive, function, pointer...?
    override bool is_basic() 
    {
        return (type.is_basic());
    }

    /// Is type a boolean?
    override bool is_bool() 
    {
        return (type.is_bool());
    }

    /// Is type constant?
    override bool is_const() 
    {
        return true;
    }

    /// Is type a string?
    override bool is_string() 
    {
        return (type.is_string());
    }
    
    /**
        Can type be casted to another type?
    
        Params:
            other = The type to be checked.
    */
    override bool can_cast_to(Type other) 
    {
        // Make sure both types are constant
        // and check them.
        return (other.is_const() && type.can_cast_to(other.get_deconsted_type()));
    }
    
    /** 
        Is other type identical to this type?
    
        Params:
            other = The type to be checked.
    */
    override bool is_identical(Type other) 
    {
        // Remove constant from other type (if needed),
        // so we can check easily.
        Type other_without_const = other;

        if (other.is_const())
            other_without_const = other.get_deconsted_type();

        // Make sure both types are constant
        // and check them.
        return (type.is_identical(other_without_const));
    }
    
    /// Remove the constant from type.
    override Type get_deconsted_type()
    {
        return type;
    }

    /// Get the name of the type.
    override string get_name() 
    {
        if (position == ConstPosition.Right)
            return ("const " ~ type.get_name());
        else
            return (type.get_name() ~ "const ");
    }
}