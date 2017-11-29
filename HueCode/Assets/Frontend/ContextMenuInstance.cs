using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class ContextMenuInstance : MonoBehaviour {
	public Action<ContextMenu> toExecute;
	public GameObject holderMenu; 
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void OnClick ()
	{
		toExecute (holderMenu.GetComponent<ContextMenu>());
	}
}
