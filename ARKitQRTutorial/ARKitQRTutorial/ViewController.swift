//
//  ViewController.swift
//  ARKitQRTutorial
//
//  Created by Alfonso Miranda Castro on 17/8/18.
//  Copyright © 2018 Alfonso Miranda Castro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
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
}

extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        // Create a Barcode Detection Request
        let request = VNDetectBarcodesRequest { (request, error) in
            // Get the first result out of the results, if there are any
            if let results = request.results, let result = results.first as? VNBarcodeObservation {
                // Get the bounding box for the bar code and find the center
                let rect = result.boundingBox
                
                // Get center
                let center = CGPoint(x: rect.midX, y: rect.midY)
                
                // Go back to the main thread
                DispatchQueue.main.async {
                    // Perform a hit test on the ARFrame to find a surface
                    let hitTestResults = frame.hitTest(center, types: [.featurePoint/*, .estimatedHorizontalPlane, .existingPlane, .existingPlaneUsingExtent*/] )
                    
                    // If we have a result, process it
                    if let hitTestResult = hitTestResults.first {
                        
                        let plane = SCNPlane(width: 0.1, height: 0.1)
                        let material = SCNMaterial()
                        material.diffuse.contents = UIColor.red
                        plane.materials = [material]
                        
                        let qrNode = SCNNode()
                        
                        
                        
                        //self.parentNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
                        
                        qrNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                                              hitTestResult.worldTransform.columns.3.y,
                                                              hitTestResult.worldTransform.columns.3.z)
                        
                        
                        self.sceneView.scene.rootNode.addChildNode(qrNode)
                        
                        
                        let detectedDataAnchor = ARAnchor(transform: hitTestResult.worldTransform)
                        self.sceneView.session.add(anchor: detectedDataAnchor)
                        
                        
                        DispatchQueue.main.async {
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            
                            if let payLoadString = result.payloadStringValue {
                                debugPrint(payLoadString)
                            }
                        }
                        
                    }
                }
                
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Create an image handler and use the CGImage your UIImage instance.
            //guard let image = frame.capturedImage else { return }
            let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, options: [:])
            
            // Perform the barcode-request. This will call the completion-handler of the barcode-request.
            guard let _ = try? handler.perform([request]) else {
                return print("Could not perform barcode-request!")
            }
        }
        
        //        // Process the request in the background
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            do {
        //                // Set it to recognize QR code only
        //                request.symbologies = [.QR]
        //
        //                // Create a request handler using the captured image from the ARFrame
        //                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage,
        //                                                                options: [:])
        //                // Process the request
        //                try imageRequestHandler.perform([request])
        //            } catch {
        //
        //            }
        //        }
    }
}
