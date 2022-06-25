module symbol;

// type/* 
import type;

// /
import file_location;
import namespace;
import source_file;

/// The kind of a symbol.
enum SymbolKind 
{
    /// This should never be the kind of a symbol.
    None,

    /// The symbol is a function.
    Function,
}

/// The property of a symbol.
enum PropertyKind
{
    // No property. 
    None,

    // The symbol is an extern function.
    Extern,
}

/// A structure that represents a symbol.
struct Symbol
{
    /// The kind of the symbol.
    SymbolKind kind;

    /// The property of the symbol.
    PropertyKind property;

    /// The namespace the symbol is located.
    Namespace *namespace;

    /// The name of the symbol.
    string name;

    /// The source file the symbol was declared.
    SourceFile *file;

    /// The location in a file where the symbol was declared.
    FileLocation location;

    /// The type of the symbol.
    Type type;
}