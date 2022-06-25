module config;

// /
import source_file;
import namespace;

/// All the exit codes.
enum ExitCode : int
{
    /// No errors happened.
    Success,

    /// An unknown error happened.
    Failure,

    /// Failed to parse command line argument.
    CommandLine,

    /// No entry point namespace found.
    Namespace,

    /// No entry point function found.
    EntryPoint,
}

/// Did any fatal error happen?
__gshared bool g_had_fatal_error = false;

/// The amount of diagnostics created.
__gshared uint g_diagnostic_amount = 0;

/// All the source files to compile.
__gshared SourceFile[] g_source_files;

/// The output directory.
__gshared string g_output_path = "output/";

/// All the namespaces.
__gshared Namespace[string] g_namespaces;