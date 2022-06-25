module diagnostic;

// /
import file_location;

/// The kind of a diagnostic error.
enum DiagnosticKind : uint
{
    /// Warning kind, doesn't stop the compilation.
    Warning,

    /// Note kind, shows information about the warning or error.
    Note,

    /// Error kind, stops the compilation.
    Error,
}

/// The color of a diagnostic error.
enum DiagnosticColor : string
{
    /// None (resets console color).
    None = "\033[0;0m",

    /// White color.
    White = "\033[37m",

    /// Green color.
    Green = "\033[32m",

    /// Warning color.
    Warning = "\033[33m",

    /// Note color.
    Note = "\033[32m",

    /// Error color.
    Error = "\033[31m",
}

/// A structure that represents a diagnostic.
struct Diagnostic
{
    /// The kind of the diagnostic.
    DiagnosticKind kind;

    /// The message of the diagnostic.
    string message;

    /// The location of the diagnostic in the file.
    FileLocation location;
}

/// Get the color of a diagnostic.
DiagnosticColor get_diagnostic_color(DiagnosticKind kind)
{
    // Check for the diagnostic kind.
    switch (kind)
    {
        // Warning diagnostic.
        case DiagnosticKind.Warning:
            return DiagnosticColor.Warning;

        // Note diagnostic.
        case DiagnosticKind.Note:
            return DiagnosticColor.Note;

        // Error diagnostic.
        case DiagnosticKind.Error:
            return DiagnosticColor.Error;

        // None.
        default:
            return DiagnosticColor.None;
    }
}

/// Get the name of a diagnostic.
string get_diagnostic_name(DiagnosticKind kind)
{
    // Check for the diagnostic kind.
    switch (kind)
    {
        // Warning diagnostic.
        case DiagnosticKind.Warning:
            return "warning";

        // Note diagnostic.
        case DiagnosticKind.Note:
            return "note";

        // Error diagnostic.
        case DiagnosticKind.Error:
            return "error";

        // None.
        default:
            return "";
    }
}