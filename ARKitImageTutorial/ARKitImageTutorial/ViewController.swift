//
//  ViewController.swift
//  ARKitImageTutorial
//
//  Created by Alfonso Miranda Castro on 13/8/18.
//  Copyright © 2018 Alfonso Miranda Castro. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration)
    }

}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        debugPrint(referenceImage.name ?? "")
        
        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25  
        
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
    }
}
