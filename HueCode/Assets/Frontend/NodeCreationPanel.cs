using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NodeCreationPanel : MonoBehaviour {
    public ListMenu thisMenu;
    public Vector2 newNodePosition;
    public GameObject nodeBase;
    public GameObject panel;
	// Use this for initialization
	void Start () {
        

	}
    public void DisablePanel ()
    {
        panel.SetActive(false);
    }

    public GameObject CreateDefaultNode ()
    {
        GameObject createdNode = Instantiate(nodeBase);
        createdNode.transform.SetParent(GameObject.Find("Canvas").transform);
        createdNode.GetComponent<RectTransform>().anchoredPosition = newNodePosition;
        createdNode.transform.SetParent(GameObject.Find("MainContent").transform);
        return createdNode;
    }
	
    public void Initialize ()
    {
        thisMenu = GetComponent<ListMenu>();
        newNodePosition = Input.mousePosition;
		/*foreach (GameObject g in thisMenu.elements)
		{
			Destroy(g);
		}*/
        thisMenu.AddElement("Class declaration", CreateClassDeclarationNode);
        thisMenu.AddElement("Namespace declaration", CreateNamespaceDeclarationNode);
        thisMenu.AddElement("Method declaration", CreateMethodDeclarationNode);
    }
    public void CreateMethodDeclarationNode(ListMenu creator)
    {
        Node thisNewNode = new MethodDeclarationNode("TemporalName", "public static", new List<Argument>() { new Argument("System.int32", "test") }, "System.void");
        GameObject MyNode = creator.gameObject.GetComponent<NodeCreationPanel>().CreateDefaultNode();
        MyNode.GetComponent<NodeRepresenter>().representating = thisNewNode;
        MyNode.GetComponent<NodeRepresenter>().Initialize();
        creator.gameObject.GetComponent<NodeCreationPanel>().DisablePanel();
    }
	public void CreateNamespaceDeclarationNode(ListMenu creator)
	{

	}
    public void CreateClassDeclarationNode (ListMenu creator)
    {
        
    }

	// Update is called once per frame
	void Update () {
		
	}
}
