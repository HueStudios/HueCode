using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PanelDisablerButton : MonoBehaviour {
    public GameObject toDisable;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public void Disable ()
    {
        toDisable.SetActive(false);
    }
}
