module linker;

// standard
import std.file;
import std.string;
import std.path;
import std.conv;

// 
import config;
import source_file;

/// A static structure that represents the linker.
struct Linker
{
    // Get the path of the file.
    static string get_path(string path)
    {
        // Get file name.
        string name = baseName(path);

        // Get file directory.
        string directory = ("_" ~ dirName(path));

        // Remove extension from file name.
        name = name[0 .. $ - 3];

        // Replace file name dots.
        name = replace(name, ".", "_");

        // Make file path.
        string file_path = ("_" ~ name);

        // Check for directory
        string file_directory = (g_output_path ~ directory);

        if (!exists(file_directory))
            mkdirRecurse(file_directory);

        // Return the path.
        return (directory ~ "/" ~ file_path);
    }

    /// Starts linking.
    static void start()
    {
        // Get runtime path.
        string runtime_path = (g_output_path ~ "otter/runtime/");

        // Make runtime directories if needed.
        if (!exists(runtime_path))
            mkdirRecurse(runtime_path);

        // Write runtime files to output path.
        write(runtime_path ~ "core.hpp",    import("core.hpp"));
        write(runtime_path ~ "include.hpp", import("include.hpp"));

        // Write every file to output path.
        foreach (ref SourceFile file; g_source_files)
        {
            // Get file path.
            string path      = get_path(file.path);
            string file_path = (g_output_path ~ path);

            // Generate header file.
            string guard   = replace(toUpper(path), "/", "_");
            string header  = "#ifndef " ~ guard ~ "_HPP\n";
                   header ~= "#define " ~ guard ~ "_HPP\n\n";
                   header ~= "#include <otter/runtime/include.hpp>\n\n";
                   header ~= file.header;
                   header ~= "\n#endif";

            // Write the header file.
            write(file_path ~ ".hpp", header);

            // Generate source file.
            string source  = "#include <" ~ path ~ ".hpp>\n";
                   source ~= file.source;

            // Remove useless line at end (if there's one).
            if (endsWith(source, "\n"))
                source = source[0 .. $ - 1];

            // Write the source file.
            write(file_path ~ ".cpp", source);
        }
    }
}