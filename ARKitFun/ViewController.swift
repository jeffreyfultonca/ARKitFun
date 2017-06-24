//
//  ViewController.swift
//  ARKitFun
//
//  Created by Jeffrey Fulton on 2017-06-23.
//  Copyright © 2017 Jeffrey Fulton. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        sceneView.automaticallyUpdatesLighting = true
        
        let rootNode = scene.rootNode
        let deathStarContainerNode = rootNode.childNode(withName: "DeathStarContainer", recursively: false)!
        
        // X-wing
        let xWingNode = deathStarContainerNode.childNode(withName: "X-wing", recursively: false)!
        xWingNode.removeFromParentNode()
        
        let orbitTwoNode = SCNNode()
        orbitTwoNode.name = "orbitTwoNode"
        orbitTwoNode.addChildNode(xWingNode)
        
        let rotationTwo = SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 5)
        let infiniteRotationTwo = SCNAction.repeatForever(rotationTwo)
        orbitTwoNode.runAction(infiniteRotationTwo)
        
        deathStarContainerNode.addChildNode(orbitTwoNode)
        
        // Tie Fighter
        let tieFighterNode = deathStarContainerNode.childNode(withName: "TieFighter", recursively: false)!
        tieFighterNode.removeFromParentNode()
        
        let orbitThreeNode = SCNNode()
        orbitThreeNode.name = "orbitThreeNode"
        orbitThreeNode.addChildNode(tieFighterNode)
        
        let rotationThree = SCNAction.rotateBy(x: 0, y: 0, z: 1, duration: 7)
        let infiniteRotationThree = SCNAction.repeatForever(rotationThree)
        orbitThreeNode.runAction(infiniteRotationThree)
        
        deathStarContainerNode.addChildNode(orbitThreeNode)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        scene.rootNode.isHidden = true
        
        let delaySeconds = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: delaySeconds) {
            scene.rootNode.isHidden = false
            
            let url = Bundle.main.url(forResource: "DeathStarTheme", withExtension: "m4a")!
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try! AVAudioSession.sharedInstance().setActive(true)
            
            self.audioPlayer = try! AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Actions
    
    @IBAction func twoTouchDoubleTap(_ sender: Any) {
        let configuration = ARWorldTrackingSessionConfiguration()
        
        sceneView.session.run(configuration, options: .resetTracking)
    }
    
}
