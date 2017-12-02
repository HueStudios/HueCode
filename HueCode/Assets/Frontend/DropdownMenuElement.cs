using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class DropdownMenuElement : MonoBehaviour {

	public GameObject textFieldToPopulate;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void OnClick()
	{
		string text = transform.Find("Text").GetComponent<Text>().text;
		textFieldToPopulate.GetComponent<InputField>().text = text;
		GetComponent<ListMenuInstance>().OnClick();
	}
}
