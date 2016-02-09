//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, HelpViewControllerDelegate, HomeSceneDelegate {
    
    let gameStruct = GameStruct()
    
    var helpViewControler:HelpViewController?
    
    
    var level = 0 {
        didSet {
            levelButtonOutlet.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            helpViewControler?.level = level
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gameScene = GameScene(level: Level0(), gameStruct: gameStruct)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
        
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: "swipeLeft:")
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target:self, action: "swipeRight:")
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let skView = view as! SKView
        if toInterfaceOrientation.isLandscape {
            skView.scene?.size = gameStruct.landscapeSceneSize
            skView.scene?.camera?.position =  gameStruct.landscapeCameraPosition
        } else {
            skView.scene?.size = gameStruct.portraitSceneSize
            skView.scene?.camera?.position =  gameStruct.portraitCameraPosition
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
        container.hidden = true
        let skView = view as! SKView
        if let scene  = skView.scene as? GameScene {
            let homeScene = HomeScene()
            homeScene.cancelScene = scene
            homeScene.userDelegate = self
            skView.presentScene(homeScene, transition: gameStruct.transitionDown)
        }
    }
    
    @IBOutlet weak var levelButtonOutlet: UIButton!
    
    @IBAction func hepButton(sender: UIButton) {
        container.hidden = !container.hidden
    }
    
    @IBOutlet weak var container: UIView!
    
    
    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        if level < HomeStruct.numberOfLevels - 1 { level++ }
        else { level = 0 }
        let nextGameScene = GameStruct.createGameScene(level)
        let skView = view as! SKView
        skView.presentScene(nextGameScene, transition: gameStruct.transitionLeft)
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if level > 0 { level-- }
        else { level = HomeStruct.numberOfLevels - 1 }
        let nextGameScene = GameStruct.createGameScene(level)
        let skView = view as! SKView
        skView.presentScene(nextGameScene, transition: gameStruct.transitionRight)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowHelp":
                helpViewControler = segue.destinationViewController as? HelpViewController
                helpViewControler!.delegate = self
            default:
                break
            }
        }
    }
    
    func close() {
        container.hidden = true
    }
    
    func updateLevel(levelNumber: Int) {
        self.level = levelNumber
    }
}
