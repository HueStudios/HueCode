using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public abstract class Node {
	public List<Plug> inputs = new List<Plug>();
	public List<Plug> outputs = new List<Plug>();
	public string caption = "Generic Node";
	public abstract string GetRepresentation();
}

public class ExecutionLink  {}
public class OwnershipLink  {}

public class Argument {
	public System.Type type;
	public string name;
	public Argument (System.Type type, string name)
	{
		this.type = type;
		this.name = name;
	}
}

public class NamespaceDeclarationNode : Node
{
	public string modifiers;
	public NamespaceDeclarationNode(string caption, string modifiers)
	{
		this.caption = caption;
		this.modifiers = modifiers;
		outputs.Add (new Plug (this, null, typeof(OwnershipLink), "Ownership", true));
	}
	public override string GetRepresentation ()
	{
		string final = "";
		final = modifiers + " namespace " + caption + " {" + outputs [0].GetRepresentationOfChildren()  + "\n}"; 
		return final;
	}
}

public class ClassDeclarationNode : Node
{
	public string modifiers;
	public ClassDeclarationNode(string caption, string modifiers)
	{
		this.caption = caption;
		this.modifiers = modifiers;
		inputs.Add (new Plug (this, null, typeof(OwnershipLink), "Ownership", false));
		outputs.Add (new Plug (this, null, typeof(OwnershipLink), "Ownership", true));
	}
	public override string GetRepresentation ()
	{
		string final = "";
		final = modifiers + " class " + caption + " {" + outputs [0].GetRepresentationOfChildren() + "\n}"; 
		return final;
	}
}

public class MethodDeclarationNode : Node
{
	public System.Type returnType;
	public string modifiers;
	public List<Argument> arguments;
	public MethodDeclarationNode(string caption, string modifiers, List<Argument> arguments, System.Type returnType)
	{
		this.caption = caption;
		this.modifiers = modifiers;
		this.arguments = arguments;
		inputs.Add (new Plug (this, null, typeof(OwnershipLink), "Ownership", true));
		outputs.Add (new Plug (this, null, typeof(ExecutionLink), "Execution", false));
		this.returnType = returnType;
		foreach (Argument arg in arguments)
		{
			outputs.Add(new Plug (this, null, arg.type, arg.name, false));
		}
	}
	public override string GetRepresentation ()
	{
		string final = "";
		string argumentsString = "";
		for (int i = 0; i < arguments.Count; i++) {
			Argument thisarg = arguments [i];
			argumentsString += thisarg.type.FullName + " " + arguments [i].name;
			if (i != arguments.Count - 1) {
				argumentsString += ", ";
			}
		}
		final = modifiers + " " + returnType.FullName + " " + caption + " (" + argumentsString + ") {\n" + outputs [0].GetRepresentationOfChildren()  + "\n}"; 
		return final;
	}
}

public class Plug
{
	public Node owner;
	public List<Plug> linkedTo = new List<Plug>();
	public bool canBeMultiple;
	public string caption;
	public System.Type type;
	public Plug (Node owner, List<Plug> linkedTo, System.Type type, string caption, bool canBeMultiple)
	{
		linkedTo = new List<Plug> ();
		this.owner = owner;
		this.linkedTo = linkedTo;
		this.type = type;
		this.caption = caption;
		this.canBeMultiple = canBeMultiple;
	}
	public string GetRepresentationOfChildren ()
	{
		if (linkedTo.Count == 0)
			return "";
		int limit;
		if (canBeMultiple)
			limit = linkedTo.Count;
		else
			limit = 1;
		string final = "";
		for (int i = 0; i < limit; i++)
		{
			final += "\n" + linkedTo [i].owner.GetRepresentation();
		}
		return final;
	}
}