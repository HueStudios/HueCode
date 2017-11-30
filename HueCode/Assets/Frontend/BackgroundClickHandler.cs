using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class BackgroundClickHandler : MonoBehaviour {


    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void ClickBackground ()
    {
		GameObject canvas = GameObject.Find("Canvas");
		if (canvas.GetComponent<DefaultContextMenu>().mainMenu) canvas.GetComponent<DefaultContextMenu>().mainMenu.GetComponent<ListMenu>().CloseMenu();
    }
}
