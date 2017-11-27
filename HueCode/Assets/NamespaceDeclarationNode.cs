using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
