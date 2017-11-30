using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class NodeRepresenter : MonoBehaviour {
	public Node representating;
	public GameObject baseInputPlug;
	public GameObject baseOutputPlug;
	public List<GameObject> inputPlugs;
	public List<GameObject> outputPlugs;
	public List<Sprite> Icons;
	// Use this for initialization
	void Start () {
		//MethodDeclarationNode methodnode = new MethodDeclarationNode("Main", "public static", new List<Argument>() {new Argument(typeof(string[]).FullName, "args")}, typeof(void).FullName);
        //representating = methodnode;
	}

	public void Initialize ()
	{
		Image nodeIcon = transform.Find ("TitleBox/NodeIcon").GetComponent<Image>();
		if (representating.GetType () == typeof(MethodDeclarationNode)) {
			nodeIcon.sprite = Icons [0];
		}
		if (representating.GetType () == typeof(ClassDeclarationNode)) {
			nodeIcon.sprite = Icons [1];
		}
		if (representating.GetType () == typeof(NamespaceDeclarationNode)) {
			nodeIcon.sprite = Icons [2];
		}
		int sizeToUse = representating.inputs.Count >= representating.outputs.Count ? representating.inputs.Count : representating.outputs.Count;
		float sizeY = 25 + sizeToUse * 25;
		RectTransform thisTransform = GetComponent<RectTransform>();
		thisTransform.sizeDelta = new Vector2 (thisTransform.rect.size.x, sizeY);
		Text nodeTitle = transform.Find ("TitleBox/NodeTitle").GetComponent<Text> ();
		nodeTitle.text = representating.caption;
		for (int i = 0; i < representating.inputs.Count; i++) {
			GameObject plugInstance = GameObject.Instantiate (baseInputPlug);
			inputPlugs.Add (plugInstance);
			plugInstance.transform.SetParent (transform);
			plugInstance.GetComponent<RectTransform>().anchoredPosition = new Vector2 (0, -35 - (25 * i));
			Text plugCaption = plugInstance.transform.Find ("CaptionHolder/InputCaption").GetComponent<Text> ();
			plugCaption.text = representating.inputs [i].caption;
		}
		for (int i = 0; i < representating.outputs.Count; i++) {
			GameObject plugInstance = GameObject.Instantiate (baseOutputPlug);
			outputPlugs.Add (plugInstance);
			plugInstance.transform.SetParent (transform);
			plugInstance.GetComponent<RectTransform>().anchoredPosition = new Vector2 (0, -35 - (25 * i));
			Text plugCaption = plugInstance.transform.Find ("CaptionHolder/OutputCaption").GetComponent<Text> ();
			plugCaption.text = representating.outputs [i].caption;
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
