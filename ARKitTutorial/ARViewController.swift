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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set the session's delegate
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        addNodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    fileprivate func addNodes() {
        let parentNode = SCNNode()
        parentNode.position = SCNVector3(0, 0, 0)
        sceneView.scene.rootNode.addChildNode(parentNode)
        
        let sphere = SCNSphere(radius: 0.4)
        sphere.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earth day")
        sphere.firstMaterial?.specular.contents = #imageLiteral(resourceName: "Earth Specular")
        sphere.firstMaterial?.emission.contents = #imageLiteral(resourceName: "Earth Emission")
        sphere.firstMaterial?.normal.contents = #imageLiteral(resourceName: "Earth Normal")
        
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(0, 0, -2)
        
        let sphere2 = SCNSphere(radius: 0.1)
        sphere2.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "moon Diffuse")
        let node2 = SCNNode(geometry: sphere2)
        node2.position = SCNVector3(0.0, 0.0, 0.8)
        node.runAction(rotation(time: 5))
        node.addChildNode(node2)
        parentNode.addChildNode(node)
        parentNode.runAction(rotation(time: 15))
    }
    
    fileprivate func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
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
        
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
