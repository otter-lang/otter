public class Module
{
	public string                     Name;
	public List<SourceFile>           Files;
	public Dictionary<string, Symbol> Symbols;

	public Module(string name)
	{
		Name    = name;
		Files   = new();
		Symbols = new();
	}
}