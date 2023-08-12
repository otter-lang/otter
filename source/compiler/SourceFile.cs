using System.Text;

public class SourceFile
{
	public string           Path;
	public string              Source;
	public Scanner             Scanner;
	public Module              Module;
	public List<Diagnostic>    Diagnostics;
	public List<Node>          Nodes;
	public List<StringBuilder> Results;
	public List<Module>        Imports;

	public SourceFile(string path)
	{
		Path        = path;
		Source      = File.ReadAllText(path);
		Scanner     = new(Source);
		Diagnostics = new();
		Nodes       = new();
		Results     = new();
		Imports     = new();
	}
}