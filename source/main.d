// standard
import core.stdc.stdlib;
import std.algorithm;
import std.stdio;
import std.file;

// /
import source_file;
import diagnostic;
import compiler;
import config;
import io;

/**
	Writes --help message to console.

	Params:
		path = The compiler path.
*/
void write_help_message(string path)
{
	write
	(
		"Otter Compiler v0.1\n",
		"Copyright (C) 2022, Otter Programming Language\n",
		"\n",
		"Usage:\n",
		"  ", path, " [<option>...] <file>...\n",
		"\n",
		"Where:\n",
		"<file>:\n",
		"  Otter source file (.ox)\n",
		"\n",
		"<option>:\n",
		"  --help   = Shows this message.\n",
		"  --output = Sets the output path.\n",
	);
}

/// Parse command line arguments.
bool parse_command_line_arguments(string[] arguments)
{
	// The error message.
	string message;

	// Loop through each argument and try parsing it.
	// NOTE: index = 1 because we skip the compiler path.
	for (uint index = 1; index < arguments.length; ++index)
	{
		// Get the current argument.
		string argument = arguments[index];

		// Is it an option?
		// Output option?
		if (argument == "--output")
		{
			// Set output path.
			if ((index + 1) < arguments.length)
				g_output_path = arguments[++index];
			else
			{
				message = "expected output path.";
				goto error;
			}
		}

		// Help option?
		else if (argument == "--help")
		{
			write_help_message(arguments[0]);
			exit(ExitCode.Success);
		}

		// Not an option?
		else
		{
			// Check if it's a source file, if not just ignore it.
			if (argument.endsWith(".ox"))
				g_source_files ~= SourceFile(argument);

			// Now check if it's a directory.
			else if (isDir(argument))
			{
				foreach (string name; dirEntries(argument, SpanMode.breadth))
				{
					if (name.endsWith(".ox"))
						g_source_files ~= SourceFile(name);
				}
			}
		}
	}

	// Check for inputs
	if (g_source_files.length == 0)
	{
		message = "no input files.";
		goto error;
	}

	return true;

	// An error happened.
	error:
		writecln(DiagnosticColor.Error, "error: " ~ message);
		return false;
}

/// Entry point function.
void main(string[] arguments)
{
	// Parse all the command line arguments.
	if (!parse_command_line_arguments(arguments))
		exit(ExitCode.CommandLine);

	// Start the compiler.
	Compiler.start();
}