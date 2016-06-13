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
    
    //let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String

    var imagineModel: ImagineModel!
    var delegate: WorldViewControllerDelegate!
    
    func displayLevel(level: Int) {
        if delegate.isLevelUnlocked() {
            switch level {
            case 0:
                textView.text = NSLocalizedString("Excellent 0", comment: "Message in the Imagine window on Levels 0 and 1.");
                textView.hidden = false
            case 1:
                textView.text = NSLocalizedString("Excellent 1", comment: "Message in the Imagine window on Levels 0 and 1.");
                textView.hidden = false
            case 2, 3:
                textView.text = NSLocalizedString("Drag the 3D scene to move the camera", comment: "Message in the Imagine window on Levels 2 and 3.");
                textView.hidden = false
            case 11, 12:
                textView.text = NSLocalizedString("Double tap to swap cameras.", comment: "Message in the Imagine window on Levels 11 and 12.");
                textView.hidden = false
            default:
                textView.hidden = true
            }
            textView.font = UIFont.systemFontOfSize(15)

            let aClass:AnyClass? =  NSClassFromString("Little_AI.ImagineModel\(level)")
            if let imagineModelType = aClass as? ImagineModel.Type
                { imagineModel = imagineModelType.init(gameModel: delegate.getGameModel()) }
            else
                { imagineModel = ImagineModel0(gameModel: delegate.getGameModel()) }
            sceneViewSetup()
        } else {
            // Fix the bug that prevents the localization of UITextView in the storyboard from working.
            self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
            textView.hidden = false
            textView.font = UIFont.systemFontOfSize(15) // fix the bug that ignores the storyboard font when "Selectable" is unchecked in the storyboard.
            sceneView.scene = nil
        }
    }
    
    /*
    override func viewDidLoad() {
        // Fix the bug that prevents the localization of UITextView in the storyboard from working.
        self.textView.text = NSLocalizedString("You must reach the score of 10", comment: "Message in the Imagine window when the user tries to see the imaginary model before reaching the score of 10.");
    }
 */

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
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
}