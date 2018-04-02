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
    
    let planeHeight: CGFloat = 0.001
    var anchors = [ARAnchor]()
    
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
        
        addNodes()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
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
    
    fileprivate func addItem(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/ship.scn")
        let node = (scene?.rootNode)!
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
        let parentNode = SCNNode()
        parentNode.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        parentNode.name = "Parent"
        
        node.position = SCNVector3(0, 0.1, 0)
        parentNode.addChildNode(node)
        
        self.sceneView.scene.rootNode.addChildNode(parentNode)
    }
    
    @objc
    fileprivate func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
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
        guard anchor is ARPlaneAnchor else {return}
        debugPrint("Plane detected!!!")
//        DispatchQueue.main.async {
//            self.planeDetected.isHidden = false
//            self.planeDetected.text = "Plane detected!!"
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.planeDetected.isHidden = true
//            self.planeDetected.text = ""
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        var node:  SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            //let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeGeometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: planeHeight, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
            //planeGeometry.cornerRadius = CGFloat(planeAnchor.extent.z / 2)
            planeGeometry.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Stars")
            //planeGeometry.firstMaterial?.specular.contents = UIColor.white
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            //planeNode.eulerAngles = SCNVector3(0, 0, 180.degreesToRadians)
            //since SCNPlane is vertical, needs to be rotated -90 degrees on X axis to make a plane //planeNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
            
        } else {
            // haven't encountered this scenario yet
            print("not plane anchor \(anchor)")
        }
        return node
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
