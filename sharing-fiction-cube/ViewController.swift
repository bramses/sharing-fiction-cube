//
//  ViewController.swift
//  sharing-fiction-cube
//
//  Created by Macbook Pro on 5/16/20.
//  Copyright © 2020 Bram. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var looper: AVPlayerLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        guard let url = Bundle.main.path(forResource: "sfgif2", ofType: "mp4") else {
            debugPrint("sfGif not found")
            return
        }
        
        
        let gif = AVPlayer(url: URL(fileURLWithPath: url))
        gif.play()
        loopVideo(gif)
        
        // add the box and material
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = gif
        
        // create a node for the box
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(0,0,-0.5)
        
        // rotate action
        let rotate = SCNAction.rotateBy(x: 360, y: 120, z: 120, duration: 1000)
        let rotateForever = SCNAction.repeatForever(rotate)
        node.runAction(rotateForever)
        
        // Set the scene to the view
        sceneView.scene = scene
        scene.rootNode.addChildNode(node)

    }
    
    // restart video with notifications
    func loopVideo(_ videoPlayer: AVPlayer) {
       NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { (_) in
           videoPlayer.seek(to: CMTime.zero)
           videoPlayer.play()
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics.insert(.personSegmentationWithDepth)

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
