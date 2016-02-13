//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameSceneDelegate, HelpViewControllerDelegate, HomeSceneDelegate, WorldViewControllerDelegate {
    
    let gameStruct = GameStruct()
    
    var helpViewController: HelpViewController?
    var worldViewController: WorldViewController?
    
    var level = 0 {
        didSet {
            levelButtonOutlet.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            helpViewController?.level = level
            worldViewController?.level = level
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gameScene = GameScene(level: Level0(), gameStruct: gameStruct)
        gameScene.gameSceneDelegate = self
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
        let swipeUp = UISwipeGestureRecognizer(target:self, action: "swipeUp:")
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target:self, action: "swipeDown:")
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
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
            homeScene.previousGameScene = scene
            homeScene.userDelegate = self
            skView.presentScene(homeScene, transition: gameStruct.transitionDown)
        }
    }
    
    @IBOutlet weak var levelButtonOutlet: UIButton!
    
    @IBAction func hepButton(sender: UIButton) {
        container.hidden = !container.hidden
    }
    
    @IBAction func worldButton(sender: UIButton) {
        container.hidden = true
        WorldViewContainer.hidden = !WorldViewContainer.hidden
    }
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var WorldViewContainer: UIView!
    
    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        let skView = view as! SKView
        if level < HomeStruct.numberOfLevels {
            level++
            let nextGameScene = GameStruct.createGameScene(level)
            nextGameScene.gameSceneDelegate = self
            skView.presentScene(nextGameScene, transition: gameStruct.transitionLeft)
        } else {
            skView.scene?.camera?.runAction(gameStruct.actionMoveCameraRightLeft)
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        let skView = view as! SKView
        if level > 0 {
            level--
            let nextGameScene = GameStruct.createGameScene(level)
            nextGameScene.gameSceneDelegate = self
            skView.presentScene(nextGameScene, transition: gameStruct.transitionRight)
        } else {
            skView.scene?.camera?.runAction(gameStruct.actionMoveCameraLeftRight)
        }
    }
    
    func swipeUp(gesture:UISwipeGestureRecognizer) {
        let skView = view as! SKView
        if let scene = skView.scene as? GameScene {
            if scene.camera?.position.y > gameStruct.portraitSceneSize.height {
                scene.camera?.runAction(gameStruct.actionMoveCameraDown)
            } else {
                scene.camera?.runAction(gameStruct.actionMoveCameraDownUp)
            }
        }
    }
    
    func swipeDown(gesture:UISwipeGestureRecognizer) {
        let skView = view as! SKView
        if let scene = skView.scene as? GameScene {
            if scene.camera?.position.y < 7 * gameStruct.portraitSceneSize.height {
                scene.camera?.runAction(gameStruct.actionMoveCameraUp)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowHelp":
                helpViewController = segue.destinationViewController as? HelpViewController
                helpViewController!.delegate = self
            case "ShowWorld":
                worldViewController = segue.destinationViewController as? WorldViewController
                worldViewController!.delegate = self
            default:
                break
            }
        }
    }
    
    func playExperience(experience: Experience) {
        worldViewController?.playExperience(experience)
    }
    
    func closeHelpView() {
        container.hidden = true
    }
    
    func closeWorldView() {
        WorldViewContainer.hidden = true
    }
    
    func updateLevel(levelNumber: Int) {
        self.level = levelNumber
    }
}
