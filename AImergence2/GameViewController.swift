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
    static let maxLevelNumber = 12
    static let unlockDefaultKey = "unlockDefaultKey"
    
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
            //levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            levelButton.setTitle("\(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }

    static let instructionInterfaceIndex = 0
    static let imagineInterfaceIndex = 1
    static let levelInterfaceIndex = 2

    let userDefaults = NSUserDefaults.standardUserDefaults()
    var interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, true])
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let userInterfaceLocks = userDefaults.arrayForKey(GameViewController.unlockDefaultKey)
        if let userIntergaceLocksBool = userInterfaceLocks as? [[Bool]] {
            if userIntergaceLocksBool.count == interfaceLocks.count {
                interfaceLocks = userIntergaceLocksBool
            }
        }
        
        let gameScene = GameSKScene(gameModel: GameModel.createGameModel(0))
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
        if interfaceLocks[level][GameViewController.levelInterfaceIndex] && level < GameViewController.maxLevelNumber {
            level += 1
            let nextGameScene = GameSKScene(gameModel: GameModel.createGameModel(level))
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionLeft)
            hideImagineViewControllerContainer()
        } else {
            sceneView.scene?.camera?.runAction(PositionedSKScene.actionMoveCameraRightLeft)
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if level > 0 {
            level -= 1
            let nextGameScene = GameSKScene(gameModel: GameModel.createGameModel(level))
            nextGameScene.gameSceneDelegate = self
            sceneView.presentScene(nextGameScene, transition: PositionedSKScene.transitionRight)
            hideImagineViewControllerContainer()
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
    }
    
    func unlockLevel() {
        if !isLevelUnlocked() {
            interfaceLocks[level][GameViewController.levelInterfaceIndex] = true
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(interfaceLocks, forKey: GameViewController.unlockDefaultKey)
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
        if let scene = sceneView.scene as? GameSKScene {
            if isImagineUnderstood() || !isLevelUnlocked() {
                scene.buttonIndex = -1
            } else {
                scene.buttonIndex = 1
            }
            scene.showButton()
        }
        interfaceLocks[level][GameViewController.instructionInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: GameViewController.unlockDefaultKey)
    }
    
    // Implement WorldViewControllerDelegate
    func hideImagineViewControllerContainer() {
        imagineViewControllerContainer.hidden = true
        imagineViewController!.sceneView.scene = nil
    }
    
    func understandImagine() {
        if let scene = sceneView.scene as? GameSKScene {
            if isInstructionUnderstood() {
                scene.buttonIndex = -1
            } else {
                scene.buttonIndex = 0
            }
            scene.showButton()
        }
        interfaceLocks[level][GameViewController.imagineInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: GameViewController.unlockDefaultKey)
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
