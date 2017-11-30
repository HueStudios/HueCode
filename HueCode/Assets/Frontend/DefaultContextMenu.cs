using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefaultContextMenu : MonoBehaviour {
    public GameObject nodeCreationPanel;
	public GameObject mainMenu;
	public ContextMenuCreator creator;
    public Vector2 fixedPosition;
	// Use this for initialization
	void Start () {
		creator = GetComponent<ContextMenuCreator> ();
	}

	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (1)) {
			Vector2 menuPosition = Input.mousePosition;
			fixedPosition = menuPosition + new Vector2 (creator.menu.GetComponent<RectTransform> ().sizeDelta.x / 2, -creator.menu.GetComponent<RectTransform> ().sizeDelta.y / 2);
			Destroy (mainMenu);
			mainMenu = creator.CreateMenu (fixedPosition);
            mainMenu.GetComponent<ListMenu> ().AddElement ("Create new node...", NewNode);
		}
        /*if (Input.GetMouseButtonDown(0))
        {
            if (mainMenu)
            {
                mainMenu.GetComponent<ListMenu>().CloseMenu();
            }
        }*/
	}

    void NewNode (ListMenu menu)
	{
        nodeCreationPanel.SetActive(true);
        GameObject.Find("NodeCreatePanelScrollView").GetComponent<NodeCreationPanel>().Initialize();
		menu.CloseMenu ();
	}

}
