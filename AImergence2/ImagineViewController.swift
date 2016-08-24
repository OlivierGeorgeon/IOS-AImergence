//
//  WorldViewController.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SceneKit

protocol ImagineViewControllerDelegate: class
{
    func acknowledgeImagineWorld()
    func closeImagineWindow()
}

class ImagineViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func closeButton(sender: UIButton) {
        delegate?.closeImagineWindow()
    }
    @IBOutlet weak var okButton: UIButton!
    @IBAction func understoodButton(sender: UIButton) {
        delegate?.acknowledgeImagineWorld()
        delegate?.closeImagineWindow()
    }

    @IBAction func elseButton(sender: UIButton)  {
        //sceneView.pointOfView = imagineModel.cameraNodes[1]
    }
    
    weak var delegate: ImagineViewControllerDelegate?

    var imagineModel: ImagineModel0!
    var experimentTried = [false]
    
    override func viewDidLoad() {
        // Called only once on startup. Then the sceneView remains loaded. Only the SceneView.scene is dismissed.
        
        // intercepts the tap gesture so it won't be transferred to the GameView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImagineViewController.tap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ImagineViewController.longPress(_:)))
        longPressGestureRecognizer.cancelsTouchesInView = false
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
        // Fix the bug that prevents the localization of UITextView in the storyboard from working.
        //self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
    }
    
    func displayLevel(gameModel: GameModel0?, okEnabled: Bool) {
        if gameModel == nil {
            // Fix the bug that prevents the localization of UITextView in the storyboard from working.
            self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
            textView.hidden = false
            textView.font = UIFont.systemFontOfSize(15) // fix the bug that ignores the storyboard font when "Selectable" is unchecked in the storyboard.
            imagineModel = nil
            sceneView.scene = nil
        } else {
            let levelNumber = gameModel!.level.number
            switch levelNumber {
            case 0:
                textView.text = NSLocalizedString("Excellent 0", comment: "Message in the Imagine window on Levels 0.");
                textView.hidden = false
            case 1:
                textView.text = NSLocalizedString("Excellent 1", comment: "Message in the Imagine window on Levels 1.");
                textView.hidden = false
            case 2:
                textView.text = NSLocalizedString("Excellent 2", comment: "Message in the Imagine window on Levels 2.");
                textView.hidden = false
            case 3:
                textView.text = NSLocalizedString("Excellent 3", comment: "Message in the Imagine window on Levels 3.");
                textView.hidden = false
            case 4:
                textView.text = NSLocalizedString("Excellent 4", comment: "Message in the Imagine window on Levels 4.");
                textView.hidden = false
            case 5:
                textView.text = NSLocalizedString("Excellent 5", comment: "Message in the Imagine window on Levels 5.");
                textView.hidden = false
            case 6:
                textView.text = NSLocalizedString("Excellent 6", comment: "Message in the Imagine window on Levels 6.");
                textView.hidden = false
            case 7:
                textView.text = NSLocalizedString("Excellent 7", comment: "Message in the Imagine window on Levels 7.");
                textView.hidden = false
            case 8:
                textView.text = NSLocalizedString("Excellent 8", comment: "Message in the Imagine window on Levels 8.");
                textView.hidden = false
            case 9, 10:
                textView.text = NSLocalizedString("Drag the 3D scene to move the camera", comment: "Message in the Imagine window on Levels 9.");
                textView.hidden = false
            case 11:
                textView.text = NSLocalizedString("Double tap to swap cameras.", comment: "Message in the Imagine window on Levels 10 and 11.");
                textView.hidden = false
            //case 12:
            //    textView.text = NSLocalizedString("Replay without bumping", comment: "Message in the Imagine window on Level 12.");
            //    textView.hidden = false
            case 12, 13:
                textView.text = NSLocalizedString("Explore your environment", comment: "Message in the Imagine window on Levels 15 and 16.");
                textView.hidden = false
            case 17:
                textView.text = NSLocalizedString("You won!", comment: "Message in the Imagine window on Levels 17 (last).");
                textView.hidden = false
            default:
                textView.hidden = true
            }
            //textView.font = UIFont.systemFontOfSize(15)
            textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

            let aClass:AnyClass? =  NSClassFromString("Little_AI.ImagineModel\(levelNumber)")
            if let imagineModelType = aClass as? ImagineModel0.Type
                { imagineModel = imagineModelType.init(gameModel: gameModel!) }
            else
                { imagineModel = ImagineModel0(gameModel: gameModel!) }
            
            if okEnabled {
                okButton.enabled = true
                experimentTried = gameModel!.level.experiments.map({_ in true})
            } else {
                okButton.enabled = false
                experimentTried = gameModel!.level.experiments.map({_ in false})
            }
            
            sceneViewSetup()
        }
    }
    
    func tap(gesture:UITapGestureRecognizer) {}
    func longPress(gesture:UILongPressGestureRecognizer) {}

    func sceneViewSetup() {
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.jitteringEnabled = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = false
        imagineModel.setup(sceneView.scene!)
    }
    
    func playExperience(experience: Experience) {
        if sceneView.scene != nil {
            imagineModel?.playExperience(experience)
            experimentTried[experience.experimentNumber] = true
            okButton.enabled = !experimentTried.contains(false)
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}