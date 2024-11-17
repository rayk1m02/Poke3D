//
//  ViewController.swift
//  Poke3D
//
//  Created by Raymond Kim on 11/16/24.
//

import UIKit
import SceneKit
import ARKit

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
        // will look for a specific image we provide in the real world
        let configuration = ARImageTrackingConfiguration()
        
        // reference images
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            
            // currently only have one card
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images Successfully Added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // anchor is the image that got detected
    // node is the 3D object that we provide in response to detecting the anchor
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        // if potential anchor
        if let imageAnchor = anchor as? ARImageAnchor {
            // use reference image width and height
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            // plane is transparent so user can view the card
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            // add our 3D plane on top of card
            let planeNode = SCNNode(geometry: plane)
            
            // rotate plane by 90 degrees, anti-clockwise along the x-axis
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
}
