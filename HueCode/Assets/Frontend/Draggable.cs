using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Draggable : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler {
	Vector2 Delta;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	public void OnBeginDrag(PointerEventData eventData) {
		Delta = this.transform.position - (Vector3)eventData.position;
	}

	public void OnDrag(PointerEventData eventData) {
		this.transform.position = eventData.position + Delta;
	}

	public void OnEndDrag(PointerEventData eventData) {
	}
}
