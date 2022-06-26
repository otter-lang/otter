module type.type_pointer;

// type/
import type.type_primitive;
import type.type;

/// A class that represents a pointer type.
class TypePointer : Type
{
    /// The base type of the pointer.
    Type base;

    /** 
        Default Constructor.

        Params:
            type = The base type of the pointer.
    */
    this(Type type)
    {
        base = type;
    }

    /// Is type null?
    override bool is_null() 
    {
        return (base.is_null());
    }

    /// Is type a primitive, function, pointer...?
    override bool is_basic() 
    {
        return true;
    }

    /// Is type a pointer?
    override bool is_pointer() 
    {
        return true;
    }
    
    /**
        Can type be casted to another type?
    
        Params:
            other = The type to be checked.
    */
    override bool can_cast_to(Type other) 
    {
        // Don't allow removing const from the type.
        if (base.is_const() && !other.is_const())
            return false;

        // Make sure both are pointers 
        // and check them.
        return (other.is_pointer() && other.is_basic());
    }
    
    /** 
        Is other type identical to this type?
    
        Params:
            other = The type to be checked.
    */
    override bool is_identical(Type other) 
    {
        // Allow null.
        if (other.is_null())
            return true;

        // *const char == string
        if (base.is_const()                                            && 
            base.get_deconsted_type().get_kind() == PrimitiveKind.Char &&
            other.is_string())
            return true;
        
        // Make sure both types are pointers 
        // and check them.
        return (other.is_pointer() && base.is_identical(other.get_derefed_type()));
    }

    /// Get size of the type.
    override int get_size()
    {
        return 8;
    }

    /// Remove the pointer from type.
    override Type get_derefed_type() 
    {
        return base;
    }

    /// Get the name of the type.
    override string get_name() 
    {
        return ("*" ~ base.get_name());
    }
}