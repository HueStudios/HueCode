using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ListMenuFilter : MonoBehaviour {
	public ListMenu toFilter;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void Filter()
	{
		string filterText = GetComponent<InputField> ().text;
		if (toFilter) {
			if (filterText == "") {
				foreach (GameObject e in toFilter.elements) {
					e.SetActive (true);
				}
			} else {
				foreach (GameObject e in toFilter.elements) {
					if (e.transform.Find ("Text").GetComponent<Text> ().text.ToLower ().Contains (filterText.ToLower ())) {
						e.SetActive (true);
					} else {
						e.SetActive (false);
					}
				}
			}
		}
	}
}
