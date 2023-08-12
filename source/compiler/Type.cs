public class Type
{
	public virtual PrimitiveKind GetKind() => PrimitiveKind.Void;
	public virtual string        GetName() => null;
	public virtual int           GetSize() => 0;

	public virtual bool IsUnsigned() => false;
	public virtual bool IsInteger () => false;
	public virtual bool IsFloat   () => false;

	public virtual bool IsIdentical(Type other) => false;
	public virtual bool IsEqual    (Type other) => false;
}

public enum PrimitiveKind
{
	Void,
	Bool,
	String,

	UByte,
	UShort,
	UInt,
	ULong,
	Byte,
	Short,
	Int,
	Long,

	Single,
	Double,
}

public class TypePrimitive : Type
{
	public PrimitiveKind Kind;

    public override PrimitiveKind GetKind() => Kind;
    public override string        GetName() => Kind.ToString().ToLower();

	public override int GetSize()
	{
		switch (Kind)
		{
			case PrimitiveKind.UByte:
			case PrimitiveKind.Byte:
			case PrimitiveKind.Bool:
				return 1;

			case PrimitiveKind.UShort:
			case PrimitiveKind.Short:
				return 2;

			case PrimitiveKind.UInt:
			case PrimitiveKind.Int:
			case PrimitiveKind.Single:
				return 4;

			case PrimitiveKind.ULong:
			case PrimitiveKind.Long:
			case PrimitiveKind.Double:
				return 8;

			default:
				return 0;
		}
	}

	public override bool IsUnsigned() => (Kind >= PrimitiveKind.UByte  && Kind <= PrimitiveKind.ULong);
	public override bool IsInteger () => (Kind >= PrimitiveKind.UByte  && Kind <= PrimitiveKind.Long);
	public override bool IsFloat   () => (Kind == PrimitiveKind.Single || Kind == PrimitiveKind.Double); 

	public override bool IsIdentical(Type other)
	{
		if (IsInteger() && other.IsInteger())
		{
			return (IsUnsigned() == other.IsUnsigned() &&
					GetSize   () == other.GetSize   ());
		}

		if (IsFloat() && other.IsFloat())
			return GetSize() == other.GetSize();

		return false;
	}

	public override bool IsEqual(Type other)
	{
		// mhmm.. I don't think this code looks right,
		// there's probably something wrong or a better
		// way to do it.

		if (IsInteger() && other.IsInteger())
			return true;

		if (IsFloat() && other.IsFloat())
			return true;

		if (IsFloat() && other.IsInteger())
			return true;

		if (IsInteger() && other.IsFloat())
			return true;

		return false;
	}
}