using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PropertiesMenuController : MonoBehaviour {
	public GameObject propertieContainer;
	public GameObject textPropertie;
	public GameObject listPropertie;
	public GameObject nodeRepresenterToEdit;
	public GameObject propertieEditPanel;
	public Transform propertieListHolder;
	List<GameObject> CurrentElements = new List<GameObject>();
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		GameObject[] objectsToChange = GameObject.FindGameObjectsWithTag("NodeTitleBox");
		foreach (GameObject g in objectsToChange)
		{
			g.GetComponent<NodeRightClickHandler>().propertiesMenu = gameObject;
			g.tag = "NodeTitleBoxChanged";
		}
	}

	public void StartMenu(GameObject nodeRepresenterToEdit)
	{
		foreach (GameObject g in CurrentElements) Destroy(g);
		CurrentElements = new List<GameObject>();
		this.nodeRepresenterToEdit = nodeRepresenterToEdit;
		propertieEditPanel.SetActive(true);
	}
}
