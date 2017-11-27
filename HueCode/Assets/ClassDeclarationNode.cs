using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClassDeclarationNode : Node
{
	public string modifiers;
	public ClassDeclarationNode(string caption, string modifiers)
	{
		this.caption = caption;
		this.modifiers = modifiers;
		inputs.Add (new Plug (this, null, typeof(OwnershipLink).FullName, "Ownership", false));
		outputs.Add (new Plug (this, null, typeof(OwnershipLink).FullName, "Ownership", true));
	}
	public override string GetRepresentation ()
	{
		string final = "";
		final = modifiers + " class " + caption + " {" + outputs [0].GetRepresentationOfChildren() + "\n}"; 
		return final;
	}
}
