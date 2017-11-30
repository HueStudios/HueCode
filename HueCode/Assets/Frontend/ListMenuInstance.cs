using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class ListMenuInstance : MonoBehaviour {
    public Action<ListMenu> toExecute;
	public GameObject holderMenu; 
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void OnClick ()
	{
        toExecute (holderMenu.GetComponent<ListMenu>());
	}
}
