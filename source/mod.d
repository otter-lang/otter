module mod;

// / 
import symbol;
import source_file;

/// A structure that represents a module.
struct Module
{
    /// The name of the module.
    string name;
    
    /// The files that "declared" this module.
    SourceFile[] files;

    /// All the symbols inside the module.
    Symbol[string] symbols;
}