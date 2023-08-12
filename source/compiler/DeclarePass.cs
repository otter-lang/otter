public class DeclarePass 
{
	public SourceFile File;

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

		// Set file module.
		File.Module = module;
	}

	public void Start()
	{
		foreach (SourceFile file in Globals.SourceFiles)
		{
			bool foundModule = false;
			bool foundBefore = false;

			File = file;

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