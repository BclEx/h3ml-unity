import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes = [UUID : Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
            .union(ARSCNDebugOptions.showFeaturePoints)
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let scene = SCNScene()
        let boxGeomtry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let boxNode = SCNNode(geometry: boxGeomtry)
        boxNode.position = SCNVector3(0, 0, -0.5)
        scene.rootNode.addChildNode(boxNode)
        
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        guard let anchorAsPlane = anchor as? ARPlaneAnchor else {
            return node
        }
        
        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let plane = Plane(anchor: anchorAsPlane)
        self.planes.updateValue(plane, forKey: anchor.identifier)
        node.addChildNode(plane)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchorAsPlane = anchor as? ARPlaneAnchor else {
            return
        }
        let plane = planes[anchor.identifier]
        plane?.update(anchor: anchorAsPlane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        planes.removeValue(forKey: anchor.identifier)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required        
    }
}
