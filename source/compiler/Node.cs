public class Node
{
	public Token Token;
}

public class NodeIdentifier : Node
{

}

public class NodeDot : Node
{
	public Node Left;
	public Node Right;
}

public class NodePrimitiveType : Node
{
	public Type Type;
}

public class NodeModule : Node
{
	public Node Name;
}

public class NodeFunction : Node
{
	public Node       Type;
	public Token      Name;
	public List<Node> Parameters;
	public Node       Body;
}

public class NodeParameter : Node
{
	public Node  Type;
	public Token Name;
}

public class NodeBlock : Node 
{
	public List<Node> Statements;
}

public class NodeNumber : Node
{
	public Token Value;
}

public class NodeReturn : Node 
{
	public Node Value;
}