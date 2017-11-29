using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContextMenuCreator : MonoBehaviour {
	public GameObject menu;
	public GameObject CreateMenu (Vector2 position)
	{
		GameObject menuInstance = GameObject.Instantiate (menu);
		menuInstance.transform.SetParent (GameObject.Find("Canvas").transform);
		menuInstance.GetComponent<RectTransform> ().anchoredPosition = position;
		return menuInstance;
	}
}
