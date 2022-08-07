module mod;

// / 
import symbol;

/// A structure that represents a module.
struct Module
{
    /// The name of the module.
    string name;

    /// All the symbols inside the module.
    Symbol[string] symbols;
}