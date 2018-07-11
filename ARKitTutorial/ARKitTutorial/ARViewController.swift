//
//  ARViewController.swift
//  ARKitTutorial
//
//  Created by Alfonso Miranda Castro on 27/3/18.
//  Copyright © 2018 alfonsomiranda. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ARViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    let planeHeight: CGFloat = 0.01
    var anchors = [ARAnchor]()
    var node: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set the session's delegate
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions .showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}

extension ARViewController: ARSCNViewDelegate, ARSessionDelegate {
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.materials.first?.diffuse.contents = #imageLiteral(resourceName: "Stars")
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
        
        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
