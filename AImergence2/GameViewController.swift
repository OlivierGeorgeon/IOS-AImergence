//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let gameStruct = GameStruct()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let gameScene = GameScene(level: Level0(), gameStruct: gameStruct)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
        
        /*
        let tapGestureRecognizer = UITapGestureRecognizer(target: skView.scene, action: "tap:")
        skView.addGestureRecognizer(tapGestureRecognizer);
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: skView.scene, action: "longPress:")
        skView.addGestureRecognizer(longPressGestureRecognizer);
*/

    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let skView = view as! SKView
        if toInterfaceOrientation.isLandscape {
            skView.scene?.size = gameStruct.landscapeSceneSize
        } else {
            skView.scene?.size = gameStruct.portraitSceneSize
        }
        
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func levelButton(sender: UIButton) {
        let skView = view as! SKView
        if let scene  = skView.scene as? GameScene {
            let homeScene = HomeScene()
            homeScene.cancelScene = scene
            skView.presentScene(homeScene, transition: gameStruct.transitionDown)
        }
    }
    
    static let segueIdentifier = "ShowHelp"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case GameViewController.segueIdentifier:
                if let hvc = segue.destinationViewController as? HelpViewController {
                    if let ppc = hvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    let skView = view as! SKView
                    if let scene  = skView.scene as? GameScene {
                        hvc.level = scene.level.number
                    }
                }
            default:
                break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
        
    }
    
}
