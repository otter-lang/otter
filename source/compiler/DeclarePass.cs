public class DeclarePass 
{
	public SourceFile File;
	
	private bool AlreadyDeclaredModule;

	private void Declare(NodeModule node)
	{
		// Get module.
		string moduleName = node.Name.GetString();

		if (!Globals.Modules.ContainsKey(moduleName))
		{
			// Add module.
			Globals.Modules.Add(moduleName, new(moduleName));
		}
		
		Module module = Globals.Modules[moduleName];

		// Add current file to module.
		module.Files.Add(File);

		// Add previous module to imports.
		if (AlreadyDeclaredModule && !File.Imports.Contains(File.Module))
			File.Imports.Add(File.Module);	

		// Set file module.
		File.Module = module;

		if (!AlreadyDeclaredModule)
			AlreadyDeclaredModule = true;
	}

	private void Declare(NodeFunction node)
	{
		// Build function symbol.
		Symbol symbol = new()
		{
			Module = File.Module,
			Type   = null,
			Name   = node.Name.Content,
		};

		// Add function symbol to file module.
		File.Module.Symbols.Add(node.Name.Content, symbol);
	}

	public void Start()
	{
		foreach (SourceFile file in Globals.SourceFiles)
		{
			bool foundModule = false;
			bool foundBefore = false;

			File                  = file;
			AlreadyDeclaredModule = false;

			foreach (Node node in file.Nodes)
			{
				switch (node)
				{
					case NodeModule module:
					{
						foundModule = true;
						Declare(module);
						break;
					}

					case NodeFunction function:
					{
						Declare(function);
						break;
					}

					default:
					{
						if (!foundModule)
							foundBefore = true;

						break;
					}
				}
			}

			// Found declarations before module declaration?
			// Add file to global module.
			if (foundBefore)
				Globals.Modules["global"].Files.Add(File);
		}
	}
}