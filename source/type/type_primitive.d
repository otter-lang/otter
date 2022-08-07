module type.type_primitive;

// type/*
import type;

// standard
import std.conv;
import std.string;

/// The kind of a primitive type.
enum PrimitiveKind : uint
{
    /// Represents a null type.
    Null,

    /// Represents a void type.
    Void,

    /// Represents a boolean type.
    Bool,

    /// Represents a string type.
    String,

    /// Represents an unsigned 8 bits character.
    UChar,

    /// Represents an unsigned 8 bits integer.
    UByte,

    /// Represents an unsigned 16 bits integer.
    UShort,

    /// Represents an unsigned 32 bits integer.
    UInt,

    /// Represents an unsigned 64 bits integer.
    ULong,

    /// Represents an unsigned pointer size integer.
    UWord,

    /// Represents a signed 8 bits character.
    Char,

    /// Represents a signed 8 bits integer.
    Byte,

    /// Represents a signed 16 bits integer.
    Short,

    /// Represents a signed 32 bits integer.
    Int,

    /// Represents a signed 64 bits integer.
    Long,

    /// Represents a signed pointer size integer.
    Word,

    /// Represents a 32 bits float.
    Single,

    /// Represents a 64 bits float.
    Double,
}

/// A class that represents a primitive type.
class TypePrimitive : Type
{
    /// The kind of the primitive type.
    PrimitiveKind kind;

    /** 
        Default Constructor.

        Params:
            kind = The kind of the primitive type.
    */
    this(PrimitiveKind kind)
    {
        this.kind = kind;
    }

    /// Is type null?
    override bool is_null() 
    {
        return (kind == PrimitiveKind.Null);
    }
    
    /// Is type void?
    override bool is_void() 
    {
        return (kind == PrimitiveKind.Void);
    }

    /// Is type a primitive, function, pointer...?
    override bool is_basic() 
    {
        return (kind != PrimitiveKind.Null &&
                kind != PrimitiveKind.Void);
    }

    /// Is type an integer?
    override bool is_integer() 
    {
        return (kind >= PrimitiveKind.UChar &&
                kind <= PrimitiveKind.Word);
    }
    
    /// Is type an unsigned integer?
    override bool is_unsigned() 
    {
        return (kind >= PrimitiveKind.UChar &&
                kind <= PrimitiveKind.UWord);
    }

    /// Is type a float?
    override bool is_float() 
    {
        return (kind == PrimitiveKind.Single ||
                kind == PrimitiveKind.Double);
    }

    /// Is type a boolean?
    override bool is_bool() 
    {
        return (kind == PrimitiveKind.Bool);
    }

    /// Is type a string?
    override bool is_string() 
    {
        return (kind == PrimitiveKind.String);
    }
    
    /**
        Can type be casted to another type?
    
        Params:
            other = The type to be checked.
    */
    override bool can_cast_to(Type other) 
    {
        // Allow casting to any basic type.
        return other.is_basic();
    }
    
    /** 
        Is other type identical to this type?
    
        Params:
            other = The type to be checked.
    */
    override bool is_identical(Type other) 
    {
        // null == null
        if (is_null() && other.is_null())
            return true;

        // void == void
        if (is_void() && other.is_void())
            return true;

        // <any integer> == <any integer>
        if (is_integer() && other.is_integer())
            return true;
            
        // <any float> == <any float>
        if (is_float() && other.is_float())
            return true;

        // <any float> == <any integer>
        if (is_float() && other.is_integer())
            return true;

        // bool == bool
        if (is_bool() && other.is_bool())
            return true;

        // string == string
        if (is_string() && other.is_string())
            return true;

        // No types matched.
        return false;
    }

    /// Get size of the type.
    override int get_size()
    {
        switch (kind)
        {
            case PrimitiveKind.UChar:
            case PrimitiveKind.Char:
            case PrimitiveKind.UByte:
            case PrimitiveKind.Byte:
            case PrimitiveKind.Bool:
                return 1;

            case PrimitiveKind.UShort:
            case PrimitiveKind.Short:
                return 2;

            case PrimitiveKind.UInt:
            case PrimitiveKind.Int:
            case PrimitiveKind.Single:
                return 4;

            case PrimitiveKind.ULong:
            case PrimitiveKind.Long:
            case PrimitiveKind.String:
            case PrimitiveKind.Double:
            case PrimitiveKind.UWord:
            case PrimitiveKind.Word:
            case PrimitiveKind.Null:
                return 8;

            default:
                return 0;
        }
    }

    /// Get the name of the type.
    override string get_name() 
    {
        return (to!(string)(kind)).toLower();
    }

    /// Get the kind of primitive type.
    override PrimitiveKind get_kind()
    {
        return kind;
    }
}