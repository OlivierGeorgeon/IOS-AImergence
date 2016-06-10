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
    func isLevelUnlocked() -> Bool
    func imagineOk()
    func getGameModel() -> GameModel2
}

class ImagineViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func closeButton(sender: UIButton) { delegate?.hideImagineViewControllerContainer() }
    @IBAction func understoodButton(sender: UIButton) {
        if delegate.isLevelUnlocked() { delegate.imagineOk() }
        delegate.hideImagineViewControllerContainer()
    }

    @IBAction func elseButton(sender: UIButton)  {
        sceneView.pointOfView = imagineModel.cameraNodes[1]
    }
    
    let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String

    var imagineModel:ImagineModel!
    var delegate: WorldViewControllerDelegate!
    private var level:Int = 0

    func displayLevel(level: Int, imagineNumber: Int = 0) {
        self.level = level
        if delegate.isLevelUnlocked() {
            if level <= 1 {
                self.textView.text = NSLocalizedString("Keep playing", comment: "Message in the Imagine window on Level 0.");
                textView.hidden = false
            } else {
                textView.hidden = true
            }
            let aClass:AnyClass? =  NSClassFromString("Little_AI.ImagineModel\(level)")
            if let imagineModelType = aClass as? ImagineModel.Type
                { imagineModel = imagineModelType.init(gameModel: delegate.getGameModel()) }
            else
                { imagineModel = ImagineModel0(gameModel: delegate.getGameModel()) }
            
            /*
            switch level {
            case 0:
                imagineModel = ImagineModel0()
            case 1:
                imagineModel = ImagineModel1()
            case 2:
                imagineModel = ImagineModel2()
            case 3:
                imagineModel = ImagineModel3()
            case 4:
                imagineModel = ImagineModel4()
            case 5:
                imagineModel = ImagineModel5()
            case 6:
                imagineModel = ImagineModel6()
            case 7:
                imagineModel = ImagineModel7()
            case 8:
                imagineModel = ImagineModel8()
            case 9:
                imagineModel = ImagineModel9()
            case 10:
                imagineModel = ImagineModel10()
            default:
                imagineModel = ImagineModel0()
            }
             */
            
            sceneViewSetup()
        } else {
            self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
            textView.hidden = false
            sceneView.scene = nil
        }
    }
    
    override func viewDidLoad() {
        // Fix the bug that prevents the localization of UITextView in the storyboard from working.
        self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
    }

    func sceneViewSetup() {
        //let scene = SCNScene(named: "Assets.xcassets/RobotPackg.dae")!
        //let scene = SCNScene(named: "art.scnassets/Robot9bJoints2.dae")!
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