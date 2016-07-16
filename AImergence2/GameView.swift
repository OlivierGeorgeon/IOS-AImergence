//
//  GameView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 27/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameViewDelegate: class
{
    func nextLevelScene() -> GameSKScene?
    func previousLevelScene() -> GameSKScene?
}

class GameView: SKView {
    
    weak var delegate: GameViewDelegate?

    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
    }
    
    func addBehavior (){
        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action: #selector(GameView.pan(_:)))
        addGestureRecognizer(panGestureRecognizer)        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.tap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameView.longPress(_:)))
        addGestureRecognizer(longPressGestureRecognizer)

        /*
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(GameView.swipeLeft(_:)))
        swipeLeft.direction = .Left
        addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(GameView.swipeRight(_:)))
        swipeRight.direction = .Right
        addGestureRecognizer(swipeRight)
        let swipeUp = UISwipeGestureRecognizer(target:self, action: #selector(GameView.swipeUp(_:)))
        swipeUp.direction = .Up
        addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target:self, action: #selector(GameView.swipeDown(_:)))
        swipeDown.direction = .Down
        addGestureRecognizer(swipeDown)
         */
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.pan(gesture)
        }
    }
    
    func tap(gesture:UITapGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.tap(gesture)
        }
    }
    
    func longPress(gesture:UILongPressGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.longPress(gesture)
        }
    }
    
    func swipeLeft(gesture:UISwipeGestureRecognizer) {
        if let scene = scene as? GameSKScene {
            let positionInScene = scene.convertPointFromView(gesture.locationInView(self))
            let positionInScreen = scene.cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: scene)
            if scene.robotNode.containsPoint(positionInScreen) { // also includes the robotNode's child nodes
                if let nextScene = delegate?.nextLevelScene() {
                    presentScene(nextScene, transition: PositionedSKScene.transitionLeft)
                } else {
                    scene.robotNode.runAction(PositionedSKScene.actionMoveCameraLeftRight)
                }
            }
        }
    }
    
    func nextLevel() {
        if let nextScene = delegate?.nextLevelScene() {
            presentScene(nextScene, transition: PositionedSKScene.transitionLeft)
        }
    }
    
    func swipeRight(gesture:UISwipeGestureRecognizer) {
        if let scene = scene as? GameSKScene {
            let positionInScene = scene.convertPointFromView(gesture.locationInView(self))
            let positionInScreen = scene.cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: scene)
            if scene.robotNode.containsPoint(positionInScreen) { // also includes the robotNode's child nodes
                if let previousScene = delegate?.previousLevelScene() {
                    presentScene(previousScene, transition: PositionedSKScene.transitionRight)
                } else {
                    scene.robotNode.runAction(PositionedSKScene.actionMoveCameraRightLeft)
                }
            }
        }
    }
    
    func previousLevel() {
        if let previousScene = delegate?.previousLevelScene() {
            presentScene(previousScene, transition: PositionedSKScene.transitionRight)
        }
    }

    func swipeUp(gesture:UISwipeGestureRecognizer) {
        if let gameScene = scene as? GameSKScene {
            if gameScene.cameraNode.position.y > 667 {
                gameScene.cameraNode.runAction(PositionedSKScene.actionMoveCameraDown)
            } else {
                gameScene.cameraNode.runAction(PositionedSKScene.actionMoveCameraDownUp)
            }
        }
    }
    
    func swipeDown(gesture:UISwipeGestureRecognizer) {
        if let gameScene = scene as? GameSKScene {
            if gameScene.cameraNode.position.y < 7 * 667 {
                gameScene.cameraNode.runAction(PositionedSKScene.actionMoveCameraUp)
            }
        }
        if let menuScene = scene as? MenuSKScene {
            presentScene(menuScene.previousGameScene!, transition: PositionedSKScene.transitionDown)
        }
    }
}