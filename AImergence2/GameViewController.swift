//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameSceneDelegate, MenuSceneDelegate, HelpViewControllerDelegate, WorldViewControllerDelegate
{
    static let maxLevelNumber = 10
    
    @IBOutlet weak var sceneView: GameView!
    @IBOutlet weak var helpViewControllerContainer: UIView!
    @IBOutlet weak var imagineViewControllerContainer: UIView!
    @IBOutlet weak var levelButton: UIButton!
    @IBAction func levelButton(sender: UIButton) {
        helpViewControllerContainer.hidden = true
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        if let scene  = sceneView.scene as? GameSKScene {
            let menuScene = MenuSKScene()
            menuScene.previousGameScene = scene
            menuScene.userDelegate = self
            sceneView.presentScene(menuScene, transition: PositionedSKScene.transitionDown)
        }
    }
    @IBAction func hepButton(sender: UIButton) {
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
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
    
    var helpViewController:  HelpViewController?
    var imagineViewController: ImagineViewController?
    var level = 0 {
        didSet {
            levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }
    
    var unlockedLevels = Array(count: GameViewController.maxLevelNumber + 1, repeatedValue: false)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gameScene = GameSKScene(gameModel: GameModel.createGameModel(0))
        gameScene.gameSceneDelegate = self
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
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
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "backgroundNodeX", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        
        // Set horiztontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "backgroundNodeX", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        sceneView.addMotionEffect(group)
    }

    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        if level < GameViewController.maxLevelNumber {
            level++
            let nextGameScene = GameSKScene(gameModel: GameModel.createGameModel(level))
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionLeft)
        } else {
            sceneView.scene?.camera?.runAction(PositionedSKScene.actionMoveCameraRightLeft)
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if level > 0 {
            level--
            let nextGameScene = GameSKScene(gameModel: GameModel.createGameModel(level))
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionRight)
        } else {
            sceneView.scene?.camera?.runAction(PositionedSKScene.actionMoveCameraLeftRight)
        }
    }
    
    func swipeUp(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameSKScene {
            if scene.cameraNode?.position.y > PositionedSKScene.portraitSize.height {
                scene.cameraNode?.runAction(PositionedSKScene.actionMoveCameraDown)
            } else {
                scene.cameraNode?.runAction(PositionedSKScene.actionMoveCameraDownUp)
            }
        }
    }
    
    func swipeDown(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameSKScene {
            if scene.cameraNode?.position.y < 7 * PositionedSKScene.portraitSize.height {
                scene.cameraNode?.runAction(PositionedSKScene.actionMoveCameraUp)
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
                imagineViewController = segue.destinationViewController as? ImagineViewController
                imagineViewController!.delegate = self
            default:
                break
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let positionedScene = sceneView.scene as? PositionedSKScene {
            positionedScene.positionInFrame(size)
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    // Implement GameSceneDelegate
    func playExperience(experience: Experience) {
        imagineViewController?.playExperience(experience)
    }
    
    func unlockLevel() {
        if !unlockedLevels[level] {
            unlockedLevels[level] = true
            if !imagineViewControllerContainer.hidden {
                imagineViewController?.displayLevel(level)
            }
        }
    }
    
    //Implement MenuSceneDelegate
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
    
    func currentLevelIsUnlocked() -> Bool {
        return unlockedLevels[level]
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
}
