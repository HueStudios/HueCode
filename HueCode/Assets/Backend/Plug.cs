using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Plug
{
	public Node owner;
	public List<Plug> linkedTo;
	public bool canBeMultiple;
	public string caption;
	public string type;
	public Plug (Node owner, List<Plug> linkedTo, string type, string caption, bool canBeMultiple)
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