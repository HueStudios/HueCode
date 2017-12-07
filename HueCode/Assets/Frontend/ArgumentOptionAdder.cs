using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArgumentOptionAdder : MonoBehaviour {

	public GameObject argumentOption;
	public GameObject optionAdder;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void AddOption()
	{
		Transform parent = transform.parent;
		GameObject newOption = Instantiate(argumentOption);
		newOption.transform.SetParent(parent);
		GameObject newAdder = Instantiate(optionAdder);
		newAdder.transform.SetParent(parent);
		Destroy(this.gameObject);
	}
}
