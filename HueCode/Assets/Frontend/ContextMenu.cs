using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class ContextMenu : MonoBehaviour {
	public GameObject contextMenuElement;
	public List<GameObject> elements = new List<GameObject>();
	public Transform elementContainer;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void AddElement(string caption, Action<ContextMenu> toExecute)
	{
		GameObject thisElement = GameObject.Instantiate (contextMenuElement);
		thisElement.transform.SetParent(elementContainer);
		elements.Add (thisElement);
		Text elementText = thisElement.transform.Find ("Text").gameObject.GetComponent<Text> ();
		elementText.text = caption;
		thisElement.GetComponent<ContextMenuInstance> ().toExecute = toExecute;
		thisElement.GetComponent<ContextMenuInstance> ().holderMenu = gameObject;
	}

	public void CloseMenu ()
	{
		Destroy (gameObject);
	}
}
