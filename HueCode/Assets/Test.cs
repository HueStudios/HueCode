using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Reflection;

public class Test : MonoBehaviour {
	List<Argument> args = new List<Argument> ();

	// Use this for initialization
	void Start () {
		args.Add (new Argument (typeof(string[]), "args"));
		MethodDeclarationNode node = new MethodDeclarationNode("Main", "public static", args, typeof(void));
		Debug.Log (node.GetRepresentation ());
		List<Type> list = new List<Type>();
		foreach (Assembly ass in AppDomain.CurrentDomain.GetAssemblies())
		{
			foreach (Type t in ass.GetExportedTypes())
			{
				if (t.IsEnum)
				{
					list.Add(t);
					Debug.Log (t);
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
