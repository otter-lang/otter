public static class GetStringExtension
{
	public static string GetString(this Node node)
	{
		switch (node)
		{
			case NodeIdentifier identifier:
				return identifier.GetString();

			case NodeDot dot:
				return dot.GetString();
		}

		return "<?>";
	}

	public static string GetString(this NodeIdentifier node)
	{
		return node.Token.Content.ToLower();
	}

	public static string GetString(this NodeDot node)
	{
		string result = "";

		switch (node.Left)
		{
			case NodeIdentifier identifier:
			{
				result += identifier.GetString();
				break;
			}

			case NodeDot dot:
			{
				result += dot.GetString();
				break;
			}
		}

		result += '.';

		switch (node.Right)
		{
			case NodeIdentifier identifier:
			{
				result += identifier.GetString();
				break;
			}

			case NodeDot dot:
			{
				result += dot.GetString();
				break;
			}
		}

		return result;
	}
}