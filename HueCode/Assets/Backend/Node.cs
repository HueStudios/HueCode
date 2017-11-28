using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;
[System.Serializable]
public class ExecutionLink  {}
[System.Serializable]
public class OwnershipLink  {}

[System.Serializable]
public abstract class Node {
	public List<Plug> inputs = new List<Plug>();
	public List<Plug> outputs = new List<Plug>();
	public string caption = "Generic Node";
	public abstract string GetRepresentation();
}




