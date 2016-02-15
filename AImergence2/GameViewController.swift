//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameSceneDelegate, HomeSceneDelegate, HelpViewControllerDelegate, WorldViewControllerDelegate
{
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var helpViewControllerContainer: UIView!
    @IBOutlet weak var imagineViewControllerContainer: UIView!
    @IBOutlet weak var levelButton: UIButton!
    
    let gameStruct = GameStruct()
    
    var helpViewController:  HelpViewController?
    var imagineViewController: WorldViewController?
    
    var level = 0 {
        didSet {
            levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gameScene = GameScene(level: Level0(), gameStruct: gameStruct)
        gameScene.gameSceneDelegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.ignoresSiblingOrder = true
        sceneView.presentScene(gameScene)
        
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let gameScene = sceneView.scene as? GameScene { gameScene.fitToParent(size) }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    @IBAction func levelButton(sender: UIButton) {
        helpViewControllerContainer.hidden = true
        imagineViewControllerContainer.hidden = true
        if let scene  = sceneView.scene as? GameScene {
            let homeScene = HomeScene()
            homeScene.previousGameScene = scene
            homeScene.userDelegate = self
            sceneView.presentScene(homeScene, transition: gameStruct.transitionDown)
        }
    }
    
    @IBAction func hepButton(sender: UIButton) {
        imagineViewControllerContainer.hidden = true
        helpViewController?.displayLevel(level)
        helpViewControllerContainer.hidden = !helpViewControllerContainer.hidden
    }
    
    @IBAction func worldButton(sender: UIButton) {
        helpViewControllerContainer.hidden = true
        if imagineViewControllerContainer.hidden {
            imagineViewController?.displayLevel(level)
            imagineViewControllerContainer.hidden = false
        } else {
            imagineViewControllerContainer.hidden = true
            imagineViewController?.sceneView.scene = nil
        }
    }
    
    
    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        if level < HomeStruct.numberOfLevels {
            level++
            let nextGameScene = GameStruct.createGameScene(level)
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: gameStruct.transitionLeft)
        } else {
            sceneView.scene?.camera?.runAction(gameStruct.actionMoveCameraRightLeft)
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if level > 0 {
            level--
            let nextGameScene = GameStruct.createGameScene(level)
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: gameStruct.transitionRight)
        } else {
            sceneView.scene?.camera?.runAction(gameStruct.actionMoveCameraLeftRight)
        }
    }
    
    func swipeUp(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameScene {
            if scene.camera?.position.y > gameStruct.portraitSceneSize.height {
                scene.camera?.runAction(gameStruct.actionMoveCameraDown)
            } else {
                scene.camera?.runAction(gameStruct.actionMoveCameraDownUp)
            }
        }
    }
    
    func swipeDown(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameScene {
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
                imagineViewController = segue.destinationViewController as? WorldViewController
                imagineViewController!.delegate = self
            default:
                break
            }
        }
    }
    
    // Implement GameSceneDelegate
    func playExperience(experience: Experience) {
        imagineViewController?.playExperience(experience)
    }
    
    //Implement HomeSceneDelegate
    func updateLevel(levelNumber: Int) {
        self.level = levelNumber
    }

    // Implement HelpViewControllerDelegate
    func hideHelpViewControllerContainer() {
        helpViewControllerContainer.hidden = true
    }
    
    // Implement WorldViewControllerDelegate
    func hideImagineViewControllerContainer() {
        imagineViewControllerContainer.hidden = true
        imagineViewController!.sceneView.scene = nil
    }
}
