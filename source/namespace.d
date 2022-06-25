module namespace;

// / 
import symbol;

/// A structure that represents a namespace.
struct Namespace
{
    /// The name of the namespace.
    string name;

    /// All the symbols inside the namespace.
    Symbol[string] symbols;
}