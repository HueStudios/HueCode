using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;


public class NodeRightClickHandler : MonoBehaviour, IPointerDownHandler {

	public void EditNodeProperties(ListMenu menu)
	{
		Debug.Log("lul");
	}
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void OnPointerDown(PointerEventData eventData)
	{
		Debug.Log("click!");
		if (eventData.button == PointerEventData.InputButton.Right)
		{
			Debug.Log("Right click");
			//GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().mainMenu.GetComponent<ListMenu>().AddElement("Edit properties...", EditNodeProperties);
			GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().newElementsText.Add("Edit properties...");
			GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().newElementsActions.Add(EditNodeProperties);
		}
	}
}
