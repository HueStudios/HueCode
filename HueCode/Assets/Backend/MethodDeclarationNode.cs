using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class MethodDeclarationNode : Node
{
	public string returnType;
	public string modifiers;
	public List<Argument> arguments;
	public MethodDeclarationNode(string caption, string modifiers, List<Argument> arguments, string returnType)
	{
		this.caption = caption;
		this.modifiers = modifiers;
		this.arguments = arguments;
		inputs.Add (new Plug (this, null, typeof(OwnershipLink).FullName, "Ownership", true));
		outputs.Add (new Plug (this, null, typeof(ExecutionLink).FullName, "Execution", false));
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
			argumentsString += thisarg.type + " " + arguments [i].name;
			if (i != arguments.Count - 1) {
				argumentsString += ", ";
			}
		}
		final = modifiers + " " + returnType + " " + caption + " (" + argumentsString + ") {\n" + outputs [0].GetRepresentationOfChildren()  + "\n}"; 
		return final;
	}
}
