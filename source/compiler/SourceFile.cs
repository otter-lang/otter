using System.Text;

public class SourceFile
{
	public string              Path;
	public string              Content;
	public Scanner             Scanner;
	public Module              Module;
	public List<Diagnostic>    Diagnostics;
	public List<Node>          Nodes;
	public List<Module>        Imports;
	public string              Header;
	public string              Source;

	public SourceFile(string path)
	{
		Path        = path;
		Content     = File.ReadAllText(path);
		Scanner     = new(Content);
		Diagnostics = new();
		Nodes       = new();
		Imports     = new();
		Header      = "";
		Source      = "";
	}
}