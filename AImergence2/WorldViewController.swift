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
    func hideImagineViewControllerContainer()
}

class WorldViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBAction func closeButton(sender: UIButton) { delegate?.hideImagineViewControllerContainer() }
    @IBAction func elseButton(sender: UIButton) { displayLevel(level) }
    
    var imagineModel = WorldScene0()
    var delegate: WorldViewControllerDelegate?
    private var level:Int = 0

    // Geometry
    var worldNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngle: Float = 0.0

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
        displayLevel(level)
    }
    
    func displayLevel(level: Int, imagineNumber: Int = 0) {
        switch level {
        case 0:
            imagineModel = WorldScene0()
            sceneSetup()
        case 1:
            imagineModel = WorldScene1()
            sceneSetup()
        case 2:
            imagineModel = WorldScene2()
            sceneSetup()
        case 3:
            imagineModel = WorldScene3()
            sceneSetup()
        default:
            imagineModel = WorldScene0()
            sceneSetup()
        }
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
        cameraNode.position = SCNVector3Make(0, 1.0, 5.0)
        scene.rootNode.addChildNode(cameraNode)
        
        let originNode = SCNNode()
        scene.rootNode.addChildNode(originNode)
        //let constraint = SCNLookAtConstraint(target: originNode)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints = [constraint]
        
        sceneView.scene = scene
        
        //sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true

        worldNode = imagineModel.worldNode
        sceneView.scene!.rootNode.addChildNode(worldNode)
    }
    
    func playExperience(experience: Experience) {
        imagineModel.playExperience(experience)
    }

    // MARK: Transition
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}