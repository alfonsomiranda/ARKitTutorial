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
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.position = SCNVector3(0,0,-2)
        sun.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        
        let earthParent = SCNNode()
        earthParent.position = SCNVector3(0,0,-2)
        
        let moonParent = SCNNode()
        moonParent.position = SCNVector3(1.2 ,0 , 0)
        
        let earth = SCNNode(geometry: SCNSphere(radius: 0.2))
        earth.position = SCNVector3(1.2 ,0 , 0)
        earth.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        let moon = SCNNode(geometry: SCNSphere(radius: 0.05))
        moon.position = SCNVector3(0,0,-0.3)
        moon.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        moonParent.addChildNode(moon)
        
        let sunAction = rotation(time: 8)
        let earthParentRotation = rotation(time: 14)
        let earthRotation = rotation(time: 8)
        let moonRotation = rotation(time: 5)
        
        earth.runAction(earthRotation)
        earthParent.runAction(earthParentRotation)
        moonParent.runAction(moonRotation)
        sun.runAction(sunAction)
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
