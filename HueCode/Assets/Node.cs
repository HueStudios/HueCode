using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public class ExecutionLink  {}
public class OwnershipLink  {}

public abstract class Node {
	public List<Plug> inputs = new List<Plug>();
	public List<Plug> outputs = new List<Plug>();
	public string caption = "Generic Node";
	public abstract string GetRepresentation();
}




