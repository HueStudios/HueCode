using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContextMenuCreator : MonoBehaviour {
	public GameObject menu;
	public GameObject mainMenu;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (1)) {
			Vector2 menuPosition = Input.mousePosition;
			Vector2 fixedPosition = menuPosition + new Vector2 (menu.GetComponent<RectTransform> ().sizeDelta.x / 2, -menu.GetComponent<RectTransform> ().sizeDelta.y / 2);
			Destroy (mainMenu);
			mainMenu = CreateMenu (fixedPosition);
			mainMenu.GetComponent<ContextMenu> ().AddElement ("Create new node...", NewNode);
		}
	}

	void NewNode (ContextMenu menu)
	{
		Debug.Log (":0");
		menu.CloseMenu ();
	}

	public GameObject CreateMenu (Vector2 position)
	{
		GameObject menuInstance = GameObject.Instantiate (menu);
		menuInstance.transform.SetParent (GameObject.Find("Canvas").transform);
		menuInstance.GetComponent<RectTransform> ().anchoredPosition = position;
		return menuInstance;
	}
}
