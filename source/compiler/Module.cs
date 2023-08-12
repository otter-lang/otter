public class Module
{
	public string           Name;
	public List<SourceFile> Files;

	public Module(string name)
	{
		Name  = name;
		Files = new();
	}
}