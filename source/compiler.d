module compiler;

// standard
import std.conv;
import std.stdio;
import core.stdc.stdlib;

// ast/ 
import ast.node;

// type/*
import type;

// /
import source_file;
import diagnostic;
import parser;
import config;
import io;
import linker;
import symbol;
import mod;

/// A static structure that represents the compiler.
struct Compiler
{
    /// Starts the compilation.
    static void start()
    {
        // Parse every source file.
        Parser parser;
	    parser.start();

        // Find entry point function symbol.
        Symbol *main_symbol = null;

loop: 
        foreach (ref Module mod; g_modules)
        {
            foreach (ref Symbol sym; mod.symbols)
            {
                if (sym.name == "main")
                {
                    main_symbol = &sym;
                    break loop;
                }
            }
        }

        // Make sure entry point function type is an integer.
        if (main_symbol !is null)
        {
            // Make sure main is a function.
            if (!main_symbol.type.is_function())
                main_symbol.file.error(main_symbol.location, "'main' must be a function.");
            else
            {
                // Make sure entry point function type is an integer.
                Type type = (cast(TypeFunction)main_symbol.type).type;

                if (type.is_const())
                    type = type.get_deconsted_type();

                if (!type.is_integer() && !type.is_void())
                    main_symbol.file.error(main_symbol.location, "entry point function type must be integer or void type.");
            }
        }

        // Emit C code.
        if (!g_had_fatal_error)
        {
            foreach (ref SourceFile source; g_source_files)
            foreach (ref Node        node;    source.nodes)
                node.emit(source);
        }

        // Write every source file diagnostic to console.
        foreach (ref SourceFile file; g_source_files)
            file.write_diagnostics();

        // Get passed message color.
        DiagnosticColor color = (g_had_fatal_error) ? DiagnosticColor.Error 
                                                    : DiagnosticColor.Green;

        // Get passed message status.
        string status = (g_had_fatal_error) ? "failure"
                                            : "successful";

        // A little grammar thing.
        string s = (g_diagnostic_amount > 1) ? "s" 
                                             : "";

        // Write passed message to console.
        if (g_diagnostic_amount > 0)
            writecln(color, "\nBuild " ~ status        ~ " with " ~ to!(string)(g_diagnostic_amount)
                                       ~ " diagnostic" ~ s        ~ ".");
        else
        {
            // Make sure entry point function exists.
            if (main_symbol is null)
            {
                writecln(DiagnosticColor.Error, "error: no entry point function 'main' found.");
                exit(ExitCode.EntryPoint);
            }

            writecln(color, "Build " ~ status ~ " with no diagnostic.");
        }

        // Link the C code (if no errors happened.)
        if (!g_had_fatal_error)
            Linker.start();
    }
}