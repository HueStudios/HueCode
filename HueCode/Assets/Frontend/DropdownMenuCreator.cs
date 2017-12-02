using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class DropdownMenuCreator : MonoBehaviour {
	public GameObject canvas;
	public GameObject specialListElement;
	public GameObject container;
	public GameObject menu;
	public GameObject menuBase;
	public List<String> menuEntries;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void ToggleMenu()
	{
		canvas = GameObject.Find("Canvas");
		container = transform.parent.gameObject;
		if (menu) Destroy(menu);
		else
		{
			menu = Instantiate(menuBase);
			Vector2 newMenuPos = new Vector2(container.transform.position.x, container.transform.position.y - 150 / 2 - 25 / 2);
			menu.transform.SetParent(canvas.transform);
			menu.GetComponent<RectTransform>().anchoredPosition = newMenuPos;
			menu.GetComponent<RectTransform>().sizeDelta = new Vector2(350, 150);
			menu.GetComponent<ListMenu>().listMenuElement = specialListElement;
			foreach (string s in menuEntries)
			{
				menu.GetComponent<ListMenu>().AddElement(s, Empty);
			}
			foreach (GameObject g in menu.GetComponent<ListMenu>().elements)
			{
				g.GetComponent<DropdownMenuElement>().textFieldToPopulate = container.transform.Find("InputField").gameObject;
			}
		}
	}
	public void Empty(ListMenu menu) { menu.CloseMenu(); } 
}
