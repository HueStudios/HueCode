using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;


public class NodeRightClickHandler : MonoBehaviour, IPointerDownHandler {

	public GameObject propertiesMenu;

	public void EditNodeProperties(ListMenu menu)
	{
		menu.CloseMenu();
		propertiesMenu.GetComponent<PropertiesMenuController>().StartMenu(GameObject.Find("Canvas").GetComponent <DefaultContextMenu>().nodeToEdit);
	}
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void OnPointerDown(PointerEventData eventData)
	{

		if (eventData.button == PointerEventData.InputButton.Right)
		{
			//GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().mainMenu.GetComponent<ListMenu>().AddElement("Edit properties...", EditNodeProperties);
			GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().newElementsText.Add("Edit properties...");
			GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().newElementsActions.Add(EditNodeProperties);
			GameObject.Find("Canvas").GetComponent<DefaultContextMenu>().nodeToEdit = transform.parent.gameObject;
		}
	}
}
