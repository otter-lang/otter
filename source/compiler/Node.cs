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

public class NodeFloat : Node
{
	public double Value;
}

public class NodeInteger : Node
{
	public long Value;
}

public class NodeString : Node
{
	public string Value;
}

public class NodeBool : Node
{
	public bool Value;
}

public class NodeNull : Node
{
	
}

public class NodeReturn : Node 
{
	public Node Value;
}