using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public abstract class Node {
	public List<Plug> inputs;
	public List<Plug> outputs;
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

public class MethodDeclarationNode : Node
{
	public System.Type returnType;
	public string methodName;
	public string modifiers;
	public List<Argument> arguments;
	public MethodDeclarationNode(string methodName, string modifiers, List<Argument> arguments, System.Type returnType)
	{
		inputs = new List<Plug> ();
		outputs = new List<Plug> ();
		this.methodName = methodName;
		this.modifiers = modifiers;
		this.arguments = arguments;
		inputs.Add (new Plug (this, null, typeof(OwnershipLink), "Ownership"));
		outputs.Add (new Plug (this, null, typeof(ExecutionLink), "Execution"));
		this.returnType = returnType;
		foreach (Argument arg in arguments)
		{
			outputs.Add(new Plug (this, null, arg.type, arg.name));
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
		final = modifiers + " " + returnType.FullName + " " + methodName + " (" + argumentsString + ") {" + outputs [0].LinkedTo.owner.GetRepresentation () + "}"; 
		return final;
	}
}

public class Plug
{
	public Node owner;
	public Plug LinkedTo;
	public string Caption;
	public System.Type type;
	public Plug (Node owner, Plug LinkedTo, System.Type type, string Caption)
	{
		this.owner = owner;
		this.LinkedTo = LinkedTo;
		this.type = type;
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