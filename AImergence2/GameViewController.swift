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
    static let maxLevelNumber = 17
    let unlockDefaultKey = "unlockDefaultKey"
    
    @IBOutlet weak var sceneView: GameView!
    @IBOutlet weak var helpViewControllerContainer: UIView!
    @IBOutlet weak var imagineViewControllerContainer: UIView!
    @IBOutlet weak var levelButton: UIButton!
    @IBAction func levelButton(sender: UIButton) { showLevelWindow() }
    @IBAction func hepButton(sender: UIButton)   { showInstructionWindow() }
    @IBAction func worldButton(sender: UIButton) { showImagineWindow() }
    
    var helpViewController:  HelpViewController?
    var imagineViewController: ImagineViewController?
    var level = 0 {
        didSet {
            levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            //levelButton.setTitle("\(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }

    static let instructionInterfaceIndex = 0
    static let imagineInterfaceIndex = 1
    static let levelInterfaceIndex = 2

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, false])
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let userInterfaceLocksWrapped = userDefaults.arrayForKey(unlockDefaultKey)
        if let userIntergaceLocks = userInterfaceLocksWrapped as? [[Bool]] {
            for i in 0...(userIntergaceLocks.count - 1) {
                interfaceLocks[i] = userIntergaceLocks[i]
            }
        }
        if Process.arguments.count > 1 {
            if Process.arguments[1] == "unlocked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, true])
            }
            if Process.arguments[1] == "locked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, false])
            }
        }
        
        let gameModel = GameModel.createGameModel(0)
        let gameScene = GameSKScene(gameModel: gameModel)
        gameScene.gameSceneDelegate = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
        sceneView.ignoresSiblingOrder = true
        sceneView.presentScene(gameScene)
        
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(GameViewController.swipeLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(GameViewController.swipeRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        let swipeUp = UISwipeGestureRecognizer(target:self, action: #selector(GameViewController.swipeUp(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target:self, action: #selector(GameViewController.swipeDown(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        /*
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
 */
    }

    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameSKScene {
            let positionInScene = scene.convertPointFromView(gesture.locationInView(sceneView))
            let positionInScreen = scene.cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: scene)
            if scene.robotNode!.containsPoint(positionInScreen) { // also includes the robotNode's child nodes
                if interfaceLocks[level][GameViewController.levelInterfaceIndex] && level < GameViewController.maxLevelNumber {
                    level += 1
                    let gameModel = GameModel.createGameModel(level)
                    let nextGameScene = GameSKScene(gameModel: gameModel)
                    nextGameScene.gameSceneDelegate = self
                    sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionLeft)
                    hideImagineViewControllerContainer()
                } else {
                    //scene.camera?.runAction(PositionedSKScene.actionMoveCameraRightLeft)
                    scene.robotNode?.runAction(PositionedSKScene.actionMoveCameraLeftRight)
                }
            }
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if let scene = sceneView.scene as? GameSKScene {
            let positionInScene = scene.convertPointFromView(gesture.locationInView(sceneView))
            let positionInScreen = scene.cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: scene)
            if scene.robotNode!.containsPoint(positionInScreen) { // also includes the robotNode's child nodes
                if level > 0 {
                    level -= 1
                    let gameModel = GameModel.createGameModel(level)
                    let nextGameScene = GameSKScene(gameModel: gameModel)
                    nextGameScene.gameSceneDelegate = self
                    sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionRight)
                    hideImagineViewControllerContainer()
                } else {
                    //scene.camera?.runAction(PositionedSKScene.actionMoveCameraLeftRight)
                    scene.robotNode?.runAction(PositionedSKScene.actionMoveCameraRightLeft)
                }
            }
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
        if let menuScene = sceneView.scene as? MenuSKScene {
            sceneView.presentScene(menuScene.previousGameScene!, transition: PositionedSKScene.transitionUp)
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
    
    func showInstructionWindow() {
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        helpViewController?.displayLevel(level)
        helpViewControllerContainer.hidden = false
    }
    
    func isLevelUnlocked() -> Bool {
        return interfaceLocks[level][GameViewController.levelInterfaceIndex]
    }
    
    func isInstructionUnderstood() -> Bool {
        return interfaceLocks[level][GameViewController.instructionInterfaceIndex]
    }
    
    func isImagineUnderstood() -> Bool {
        return interfaceLocks[level][GameViewController.imagineInterfaceIndex]
    }
    
    func isInterfaceUnlocked(interface: Int) -> Bool {
        return interfaceLocks[level][interface]
    }

    func showImagineWindow() {
        helpViewControllerContainer.hidden = true
        if imagineViewControllerContainer.hidden {
            imagineViewController?.displayLevel(level)
            imagineViewControllerContainer.hidden = false
        } else {
            imagineViewControllerContainer.hidden = true
            imagineViewController?.sceneView.scene = nil
        }
    }
    
    func showLevelWindow() {
        helpViewControllerContainer.hidden = true
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        if let scene  = sceneView.scene as? GameSKScene {
            let menuScene = MenuSKScene()
            menuScene.previousGameScene = scene
            menuScene.userDelegate = self
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            sceneView.presentScene(menuScene, transition: PositionedSKScene.transitionDown)
        }
        if let menuScene  = sceneView.scene as? MenuSKScene {
            sceneView.presentScene(menuScene.previousGameScene!, transition: PositionedSKScene.transitionUp)            
        }
    }
    
    func unlockLevel() {
        if !isLevelUnlocked() {
            interfaceLocks[level][GameViewController.levelInterfaceIndex] = true
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
            if !imagineViewControllerContainer.hidden {
                imagineViewController?.displayLevel(level)
            }
        }
    }
    
    //Implement MenuSceneDelegate
    func currentlevel() -> Int {
        return level
    }
    
    func updateLevel(levelNumber: Int) {
        self.level = levelNumber
    }
    
    func levelStatus(level: Int) -> Int {
        var levelStatus = 0 // forbidden
        if level == 0 { levelStatus = 1 } //  allowed
        if level > 0 {
            if interfaceLocks[level - 1][GameViewController.levelInterfaceIndex]
                {levelStatus = 1 }
        }
        if interfaceLocks[level][GameViewController.levelInterfaceIndex]
            { levelStatus = 2 } // unlocked
        return levelStatus
    }

    // Implement HelpViewControllerDelegate
    func hideHelpViewControllerContainer() {
        helpViewControllerContainer.hidden = true
    }
    
    func understandInstruction() {
        interfaceLocks[level][GameViewController.instructionInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            if isImagineUnderstood() || !isLevelUnlocked() {
                scene.buttonIndex = -1
            } else {
                scene.buttonIndex = 1
            }
            scene.showButton()
        }
    }
    
    // Implement WorldViewControllerDelegate
    func hideImagineViewControllerContainer() {
        imagineViewControllerContainer.hidden = true
        imagineViewController!.sceneView.scene = nil
    }
    
    func getGameModel() -> GameModel2 {
        var gameModel = GameModel2()
        if let scene = sceneView.scene as? GameSKScene {
            gameModel = scene.gameModel
        }
        return gameModel
    }
    
    func imagineOk() {
        interfaceLocks[level][GameViewController.imagineInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            if isInstructionUnderstood() {
                scene.buttonIndex = 2
            } else {
                scene.buttonIndex = 0
            }
            scene.showButton()
        }
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
