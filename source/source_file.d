module source_file;

// ast/*
import ast;

// /
import diagnostic;
import file_location;
import namespace;
import scanner;
import symbol;
import config;
import io;

// standard
import std.string;
import std.stdio;
import std.file;
import std.conv;
import std.array;

/// A structure that represents a source file.
struct SourceFile
{
    /// The path of the source file.
    string path;

    /// The content of the source file.
    string content;

    /// The scanner the source file uses.
    Scanner scanner;
    
    /// All the diagnostics of the source file.
    Diagnostic[] diagnostics;

    /// All the nodes generated by the parser.
    Node[] nodes;

    /// The C header generated by the compiler.
    string header;

    /// The C source generated by the compiler.
    string source;

    /// The amount of tabs being generated in the C source.
    uint tabs;

    /// The current function symbol we're emitting/checking.
    Symbol *current_function;

    /// The current namespace we're inside.
    Namespace *current_namespace;

    /// The current symbol being used.
    Symbol *current_symbol;

    /// The namespaces being used.
    Namespace *[]namespaces;
    
    /**
        Default Constructor.

        Params:
            path = The path of the source file.
    */
    this(string path)
    {
        // Set the path.
        this.path = path;

        // Read the file's content.
        // NOTE: A null terminator is added, so it's easier to scan.
        content = (readText(path) ~ '\0');

        // Set the scanner.
        scanner = Scanner(content);
    }

    /**
        Adds warning diagnostic to source file.

        Params:
            location = The file location of where the diagnostic points to.
            message  = The message of the diagnostic.
    */
    void warning(FileLocation location, string message)
    {
        diagnostics ~= Diagnostic
        (
            DiagnosticKind.Warning, 
            message,
            location,
        );

        // Increase diagnostic amount.
        ++g_diagnostic_amount;
    }

    /**
        Adds note diagnostic to source file.

        Params:
            location = The file location of where the diagnostic points to.
            message  = The message of the diagnostic.
    */
    void note(FileLocation location, string message)
    {
        diagnostics ~= Diagnostic
        (
            DiagnosticKind.Note, 
            message,
            location,
        );

        // Increase diagnostic amount.
        ++g_diagnostic_amount;
    }

    /**
        Adds error diagnostic to source file.

        Params:
            location = The file location of where the diagnostic points to.
            message  = The message of the diagnostic.
    */
    void error(FileLocation location, string message)
    {
        diagnostics ~= Diagnostic
        (
            DiagnosticKind.Error, 
            message,
            location,
        );

        // Set global had fatal error to true.
        g_had_fatal_error = true;

        // Increase diagnostic amount.
        ++g_diagnostic_amount;
    }

    /// Write diagnostics to console.
    void write_diagnostics()
    {
        // Go through each diagnostic and write
        // them to console.
        foreach (ref Diagnostic diagnostic; diagnostics)
        {
            // Get the diagnostic location.
            FileLocation location = diagnostic.location;

            // Get diagnostic color.
            DiagnosticColor color = get_diagnostic_color(diagnostic.kind);

            // Get diagnostic name.
            string name = get_diagnostic_name(diagnostic.kind);

            // Write file information and diagnostic message to console.
            writec(DiagnosticColor.White, "(" ~ path ~ ":" ~ to!(string)(location.line) 
                                              ~ ":" ~ to!(string)(location.column)
                                              ~ ") " ~ "");
            writec(color, name);
            writecln(DiagnosticColor.White, ": " ~ diagnostic.message);

            // Skip all the whitespaces.
            const(char) *skipped = location.line_start;

            while (((*skipped) == ' ') || ((*skipped) == '\r') ||
                   ((*skipped) == '\t'))
                ++skipped;

            // Get line information to write.
            string line = (to!(string)(location.line) ~ " ");
        
            // Write "<line length spacing>|" to console.
            for (uint i = 0; i < line.length; ++i)
                write(' ');

            writecln(DiagnosticColor.White, "|");

            // Write "<line> | <line content>" to console.
            writec(color, line);
            writec(DiagnosticColor.White, "| ");

            const(char) *line_content = skipped;

            while ((*line_content) != '\0' && ((*line_content) != '\n'))
                writec(DiagnosticColor.White, to!(string)(*line_content++));

            writeln();

            // Write "<line length spacing>| " to console.
            for (uint i = 0; i < line.length; ++i)
                write(' ');

            writec(DiagnosticColor.White, "| ");

            // Get arrow start position.
            int distance = (cast(int)(skipped - location.line_start));
            int start    = (location.column > distance) ? (location.column - distance - location.length - 1)
                                                        : 0;
        
            // Write "<spacing>" to console.
            for (int i = 0; i < start; ++i)
                write(' ');

            // Write "^~~~..." to console.
            writec(color, "^");

            for (uint i = 1; i < location.length; ++i)
                writec(color, "~");

            writeln();
        }
    }

    /// Write the amount of tabs in source.
    void write_tabs()
    {
        for (uint i = 0; i < tabs; ++i)
            source ~= '\t';
    }

    /** 
        Mangle name.

        Params:
            name = The name to be mangled.
    */
    string mangle_name(string name)
    {
        // Check for symbol.
        if ((name in current_namespace.symbols) is null)
            return name;

        // Mangle symbol (if not extern).
        Symbol symbol = current_namespace.symbols[name];
        return mangle_symbol(&symbol);
    }

    /** 
        Mangle symbol.

        Params:
            name = The symbol to be mangled.
    */
    string mangle_symbol(Symbol *symbol)
    {
        if (symbol.property == PropertyKind.Extern)
            return symbol.name;

        string fprefix = "";

        if (symbol.kind == SymbolKind.Parameter)
            fprefix = current_function.name ~ "_";

        return (symbol.namespace.name.replace(".", "_") ~ "_" ~ fprefix ~ symbol.name);
    }

    /** 
        Find symbol.

        Params:
            name = The name of the symbol to be found.
    */
    Symbol *find_symbol(string name)
    {
        current_symbol = null;

        // Check for any dot, if there's one then we need to 
        // try finding the symbol globally or locally too 
        // (because static classes/structures). 
        if (name.indexOf('.') != -1)
        {
            // TODO
            return current_symbol;
        }
        // There's no dot, it's a symbol that is local or is in
        // a namespace being used.
        else if (current_namespace !is null)
        {
            // Try finding the symbol locally first.
            if ((name in current_namespace.symbols) !is null)
                current_symbol = (&current_namespace.symbols[name]);

            // Try finding the symbol globally.
            if ((name in g_namespaces["global"].symbols) !is null)
                current_symbol = (&g_namespaces["global"].symbols[name]);

            // Try finding the symbol inside used namespaces.
            foreach (Namespace *used_namespace; namespaces)
            {
                if ((name in used_namespace.symbols) !is null)
                {
                    current_symbol = (&used_namespace.symbols[name]);
                    break;
                }
            }

            // We didn't find this symbol.
            return current_symbol;
        }
        
        return null;
    }
}