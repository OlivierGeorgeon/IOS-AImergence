//
//  WorldViewController.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SceneKit

protocol WorldViewControllerDelegate
{
    func closeWorldView()
}

class WorldViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBAction func closeButton(sender: UIButton) {
        delegate?.closeWorldView()
    }

    var worldScene = WorldScene0()
    var delegate: WorldViewControllerDelegate?
    var level:Int = 0 {
        didSet {
            switch level {
            case 0:
                worldScene = WorldScene0()
                sceneSetup()
            default:
                worldScene = WorldScene1()
                sceneSetup()
            }
        }
    }

    // Geometry
    var worldNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngle: Float = 0.0

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
    }

    // MARK: Scene
    func sceneSetup() {
        // 1
        let scene = SCNScene()
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 1.0, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        //sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true

        worldNode = worldScene.worldNode
        sceneView.scene!.rootNode.addChildNode(worldNode)
    }
    
    func playExperience(experience: Experience) {
        worldScene.playExperience(experience)
    }

    // MARK: Transition
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}