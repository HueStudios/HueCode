using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Reflection;

public class Test : MonoBehaviour {
	List<Argument> args = new List<Argument> ();

	// Use this for initialization
	void Start () {
		NamespaceDeclarationNode namenode = new NamespaceDeclarationNode ("HueCode", "public");
		ClassDeclarationNode classnode = new ClassDeclarationNode ("Test", "public");
		args.Add (new Argument (typeof(string[]), "args"));
		MethodDeclarationNode methodnode = new MethodDeclarationNode("Main", "public static", args, typeof(void));
		MethodDeclarationNode methodnode2 = new MethodDeclarationNode("SayHi", "public static", args, typeof(void));
		namenode.outputs [0].LinkedTo.Add(classnode.inputs [0]);
		classnode.outputs [0].LinkedTo.Add(methodnode.inputs [0]);
		classnode.outputs [0].LinkedTo.Add(methodnode2.inputs [0]);
		Debug.Log (namenode.GetRepresentation ());
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
