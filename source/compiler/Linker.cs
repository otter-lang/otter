public class Linker 
{
	private string GetPath(string path)
	{
		// Get file name.
		string fileName = Path.GetFileNameWithoutExtension(path);

		// Replace (i forgot why I do that).
		fileName = fileName.Replace(".", "_");

		// Get file directory.
		string directory = ("user/" + Path.GetDirectoryName(path));

		// Check if directory exists.
		string fullDirectory = (Globals.Path + directory);

		if (!Directory.Exists(fullDirectory))
		{
			// Create it then.
			Directory.CreateDirectory(fullDirectory);
		}

		return (directory + '/' + fileName);
	}

	public void Start()
	{
		// Clear output directory.
		if (Directory.Exists(Globals.Path))
			Directory.Delete(Globals.Path, true);

		Directory.CreateDirectory(Globals.Path);

		// Write directories.
		string runtimePath = (Globals.Path + "otter/runtime/");
		string modulesPath = (Globals.Path + "modules/");

		Directory.CreateDirectory(runtimePath);
		Directory.CreateDirectory(modulesPath);

		// Write runtime files.

		// Write modules.
		foreach ((string key, Module module) in Globals.Modules)
		{
			// Don't write if it's empty.
			if (module.Files.Count == 0)
				continue;

			// Get module path.
			string modulePath = (modulesPath + module.Name + ".hpp");

			// Generate header file.
			string headerGuard = modulePath.ToUpper().Replace(".", "_").Replace("/", "_");
			string header = "";

			header += "#ifndef " + headerGuard + "\n";
			header += "#define " + headerGuard + "\n\n";

			foreach (SourceFile file in module.Files)
				header += "#include <" + GetPath(file.Path) + ".hpp>\n";
			
			header += "\n#endif";
			
			// Write header file.
			File.WriteAllText(modulePath, header);
		}

		// Write headers and source files.
		foreach (SourceFile file in Globals.SourceFiles)
		{
			// Get file path.
			string path       = GetPath(file.Path);
			string outputPath = (Globals.Path + path);

			// Generate header file.
			string headerGuard = path.ToUpper().Replace("/", "_");
			string header = "";

			header += "#ifndef " + headerGuard + "\n";
			header += "#define " + headerGuard + "\n\n";

			// TODO: runtime include.

			header += file.Header;
			header += "\n#endif";

			// Write header file.
			File.WriteAllText(outputPath + ".hpp", header);

			// Generate source file.
			string source = "";

			source += $"#include <modules/{file.Module.Name}.hpp>\n";

			foreach (Module module in file.Imports)
				source += $"#include <modules/{module.Name}.hpp>\n";

			source += "\n";
			source += file.Source;

			// Formatting: Remove unnecessary newline at end.
			if (source.EndsWith("\n"))
				source = source.Substring(0, source.Length - 1); 		

			// Write source file.
			File.WriteAllText(outputPath + ".cpp", source);
		}
	}
}