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
    func currentLevelIsUnlocked() -> Bool
}

class ImagineViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func closeButton(sender: UIButton) { delegate?.hideImagineViewControllerContainer() }
    @IBAction func elseButton(sender: UIButton)  { //sceneView.pointOfView = imagineModel.cameraNodes[1] 
    }
    
    let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String

    var imagineModel:ImagineModel!
    var delegate: WorldViewControllerDelegate!
    private var level:Int = 0

    func displayLevel(level: Int, imagineNumber: Int = 0) {
        self.level = level
        if delegate.currentLevelIsUnlocked() {
            textView.hidden = true
            let aClass =  NSClassFromString(bundleName + ".ImagineModel\(level)") as! ImagineModel.Type
            imagineModel = aClass.init()
            if imagineModel == nil { imagineModel = ImagineModel4() }
            sceneViewSetup()
        } else {
            textView.hidden = false
            sceneView.scene = nil
        }
    }

    func sceneViewSetup() {
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.jitteringEnabled = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = false
        imagineModel.setup(scene)
    }
    
    func playExperience(experience: Experience) {
        imagineModel?.playExperience(experience)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}