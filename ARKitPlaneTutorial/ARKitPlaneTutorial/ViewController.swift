//
//  ViewController.swift
//  ARKitPlaneTutorial
//
//  Created by Alfonso Miranda Castro on 10/7/18.
//  Copyright © 2018 Alfonso Miranda Castro. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!

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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateModel))
        sceneView.addGestureRecognizer(rotationGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
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
    
    fileprivate func addItem(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "Models.scnassets/cup.scn")
        let node = (scene?.rootNode)!
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y + 0.1, thirdColumn.z)
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {
                return
            }
            
            let node = hitResult.node
            
            let translation = recognizer.translation(in: recognizer.view!)
            
            let x = Float(translation.x)
            let y = Float(-translation.y)
            
            let anglePan = sqrt(pow(x, 2) + pow(y, 2)) * (Float)(Double.pi)/180.0
            
            var rotationVector = SCNVector4()
            rotationVector.x = 0//-y
            rotationVector.y = x
            rotationVector.z = 0
            rotationVector.w = anglePan
            
            node.rotation = rotationVector
        }
    }
    
    private var originalRotation: SCNVector3?
    
    @objc private func rotateModel(_ gesture: UIRotationGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard let node = sceneView.hitTest(location, options: nil).first?.node else { return }
        
        switch gesture.state {
        case .began:
            originalRotation = node.eulerAngles
        case .changed:
            guard var originalRotation = originalRotation else { return }
            originalRotation.y -= Float(gesture.rotation)
            node.eulerAngles = originalRotation
        default:
            originalRotation = nil
        }
    }

}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.materials.first?.diffuse.contents = UIColor.red
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
