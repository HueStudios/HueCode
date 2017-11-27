using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Argument {
	public System.Type type;
	public string name;
	public Argument (System.Type type, string name)
	{
		this.type = type;
		this.name = name;
	}
}