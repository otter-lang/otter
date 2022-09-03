module linker;

// standard
import std.file;
import std.string;
import std.path;
import std.conv;

// 
import config;
import source_file;
import mod;

/// A static structure that represents the linker.
struct Linker
{
    // Get the path of the file.
    static string get_path(string path)
    {
        // Get file name.
        string name = baseName(path);

        // Get file directory.
        string directory = ("user/" ~ dirName(path));

        // Remove extension from file name.
        name = name[0 .. $ - 3];

        // Replace file name dots.
        name = replace(name, ".", "_");

        // Check for directory
        string file_directory = (g_output_path ~ directory);

        if (!exists(file_directory))
            mkdirRecurse(file_directory);

        // Return the path.
        return (directory ~ "/" ~ name);
    }

    /// Starts linking.
    static void start()
    {
        // Get runtime path.
        string runtime_path = (g_output_path ~ "otter/runtime/");

        // Get module path.
        string module_path = (g_output_path ~ "modules/");

        // Clear output path.
        // TODO: find a better way.
        rmdirRecurse(g_output_path);
        mkdirRecurse(g_output_path);

        // Make runtime directories if needed.
        if (!exists(runtime_path))
            mkdirRecurse(runtime_path);

        // Write runtime files to output path.
        write(runtime_path ~ "core.hpp",    import("core.hpp"));
        write(runtime_path ~ "include.hpp", import("include.hpp"));

        // Make module directory if needed.
        if (!exists(module_path))
            mkdirRecurse(module_path);

        // Write module files to module path;
        foreach (ref Module mod; g_modules)
        {
            // Get module file path.
            string path = module_path ~ mod.name ~ ".hpp";

            // Generate header file.
            string guard   = replace(replace(toUpper(path), ".", "_"), "/", "_");
            string header  = "#ifndef " ~ guard ~ "\n";
                   header ~= "#define " ~ guard ~ "\n\n";

            foreach (ref SourceFile file; mod.files)
                   header ~= "#include <" ~ get_path(file.path) ~ ".hpp>\n";

                   header ~= "\n#endif";

            // Write header file.
            write(path, header);
        }

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
                   header ~= "#include <otter/runtime/include.hpp>\n";
                   header ~= "\n";
                   header ~= file.header;
                   header ~= "\n#endif";

            // Write the header file.
            write(file_path ~ ".hpp", header);

            // Generate source file.
            string source  = "#include <modules/" ~ file.mod.name ~ ".hpp>\n";

            foreach (Module *mod; file.imports)
                   source ~= "#include <modules/" ~ mod.name ~ ".hpp>\n";

                   source ~= file.source;

            // Remove useless line at end (if there's one).
            if (endsWith(source, "\n"))
                source = source[0 .. $ - 1];

            // Write the source file.
            write(file_path ~ ".cpp", source);
        }
    }
}