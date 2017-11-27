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
	public List<Plug> LinkedTo = new List<Plug>();
	public bool CanBeMultiple;
	public string Caption;
	public System.Type type;
	public Plug (Node owner, List<Plug> LinkedTo, System.Type type, string Caption, bool CanBeMultiple)
	{
		LinkedTo = new List<Plug> ();
		this.owner = owner;
		this.LinkedTo = LinkedTo;
		this.type = type;
		this.Caption = Caption;
		this.CanBeMultiple = CanBeMultiple;
	}
	public string GetRepresentationOfChildren ()
	{
		if (LinkedTo.Count == 0)
			return "";
		int limit;
		if (CanBeMultiple)
			limit = LinkedTo.Count;
		else
			limit = 1;
		string Final = "";
		for (int i = 0; i < limit; i++)
		{
			Final += "\n" + LinkedTo [i].owner.GetRepresentation();
		}
		return Final;
	}
}



public class Utils {
	public static string GetCSharpRepresentation( Type t, bool trimArgCount ) {
		if( t.IsGenericType ) {
			var genericArgs = t.GetGenericArguments().ToList();

			return GetCSharpRepresentation( t, trimArgCount, genericArgs );
		}

		return t.Name;
	}
	public static string GetCSharpRepresentation( Type t, bool trimArgCount, List<Type> availableArguments ) {
		if( t.IsGenericType ) {
			string value = t.Name;
			if( trimArgCount && value.IndexOf("`") > -1 ) {
				value = value.Substring( 0, value.IndexOf( "`" ) );
			}
				
			if( t.DeclaringType != null ) {
				// This is a nested type, build the nesting type first
				value = GetCSharpRepresentation( t.DeclaringType, trimArgCount, availableArguments ) + "+" + value;
			}

			// Build the type arguments (if any)
			string argString = "";
			var thisTypeArgs = t.GetGenericArguments();
			for( int i = 0; i < thisTypeArgs.Length && availableArguments.Count > 0; i++ ) {
				if( i != 0 ) argString += ", ";

				argString += GetCSharpRepresentation( availableArguments[0], trimArgCount );
				availableArguments.RemoveAt( 0 );
			}
				
			// If there are type arguments, add them with < >
			if( argString.Length > 0 ) {
				value += "<" + argString + ">";
			}
				
			return value;
		}

		return t.Name;
	}
}