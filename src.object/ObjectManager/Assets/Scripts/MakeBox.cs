using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MakeBox : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {

        var chair = Resources.Load("Hatchet");

        var box = Instantiate(GameObject.Find("Cube00"), this.transform);
        box.transform.position += new Vector3(2, 2, 2);
        Debug.Log("Test");
        //GameObject.Destroy(box);
    }

    // Update is called once per frame
    void Update()
    {
    }
}
