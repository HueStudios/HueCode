using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefaultContextMenu : MonoBehaviour {

	public GameObject mainMenu;
	public ContextMenuCreator creator;
	// Use this for initialization
	void Start () {
		creator = GetComponent<ContextMenuCreator> ();
	}

	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (1)) {
			Vector2 menuPosition = Input.mousePosition;
			Vector2 fixedPosition = menuPosition + new Vector2 (creator.menu.GetComponent<RectTransform> ().sizeDelta.x / 2, -creator.menu.GetComponent<RectTransform> ().sizeDelta.y / 2);
			Destroy (mainMenu);
			mainMenu = creator.CreateMenu (fixedPosition);
			mainMenu.GetComponent<ContextMenu> ().AddElement ("Create new node...", NewNode);
		}
	}

	void NewNode (ContextMenu menu)
	{
		Debug.Log (":0");
		menu.CloseMenu ();
	}

}
