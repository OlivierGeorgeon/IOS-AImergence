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
    @IBAction func elseButton(sender: UIButton) //{ displayLevel(level) }
    { sceneView.pointOfView = imagineModel.cameraNodes[1] }
    
    var imagineModel = WorldScene0()
    var delegate: WorldViewControllerDelegate?
    private var level:Int = 0

    func displayLevel(level: Int, imagineNumber: Int = 0) {
        self.level = level
        switch level {
        case 0:
            imagineModel = WorldScene0()
            sceneViewSetup()
        case 1:
            imagineModel = WorldScene1()
            sceneViewSetup()
        case 2:
            imagineModel = WorldScene2()
            sceneViewSetup()
        case 3:
            imagineModel = WorldScene3()
            sceneViewSetup()
        case 4, 5, 6:
            imagineModel = WorldScene4()
            sceneViewSetup()
        case 7:
            imagineModel = WorldScene7()
            sceneViewSetup()
        default:
            imagineModel = WorldScene0()
            sceneViewSetup()
        }
    }

    func sceneViewSetup() {
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.jitteringEnabled = true
        //sceneView.showsStatistics = true
        //sceneView.autoenablesDefaultLighting = true
        imagineModel.setup(scene)
    }
    
    func playExperience(experience: Experience) {
        imagineModel.playExperience(experience)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}