//
//  GameView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 27/02/16.
//  CC0 No rights reserved.
//

import Foundation
import SpriteKit
import GameKit

protocol GameViewDelegate: class
{
    func nextLevelScene() -> GameSKScene? 
    func previousLevelScene() -> GameSKScene?
}

class GameView: SKView, UIGestureRecognizerDelegate {
    
    weak var gameViewDelegate: GameViewDelegate? // Swift 3
    
    let doubleTapGesture = UITapGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    var verticalPan = false

    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
    }
    
    func addBehavior() {
        panGestureRecognizer.addTarget(self, action: #selector(GameView.pan(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.tap(_:)))
        addGestureRecognizer(tapGestureRecognizer)

        longPressGestureRecognizer.addTarget(self, action: #selector(GameView.longPress(_:)))
        longPressGestureRecognizer.delegate = self
        addGestureRecognizer(longPressGestureRecognizer)
        
        doubleTapGesture.addTarget(self, action: #selector(GameView.doubleTap(_:)))
        doubleTapGesture.isEnabled = true
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    func pan(_ gesture: UIPanGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.pan(gesture)
        }
    }
    
    func tap(_ gesture:UITapGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.tap(gesture)
        }
    }
    
    func longPress(_ gesture:UILongPressGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.longPress(gesture)
        }
    }
    
    func nextLevel() {
        if let nextScene = gameViewDelegate?.nextLevelScene() { // Swift 3
            presentScene(nextScene, transition: nextScene.transitionLeft)
        }
    }

    func previousLevel() {
        if let previousScene = gameViewDelegate?.previousLevelScene() { // Swift 3
            presentScene(previousScene, transition: previousScene.transitionRight)
        }
    }
    
    func doubleTap(_ gesture:UITapGestureRecognizer) {
        if let scene = scene as? GameSKScene {
            scene.doubleTap(gesture)
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        var inGameScene = false
        var inRobotNode = false
        var inExperimentNode =  false
        var inNextExperimentNode = false
        var inTraceNode = false
        if let scene = scene as? GameSKScene {
            inGameScene = true
            let positionInScene = scene.convertPoint(fromView: gestureRecognizer.location(in: self))
            let positionInScreen = scene.cameraRelativeOriginNode.convert(positionInScene, from: scene)
            inRobotNode = scene.robotNode.contains(positionInScreen)
            for experimentNode in scene.experimentNodes.values {
                if experimentNode.contains(positionInScene){
                    inExperimentNode = true
                }
            }
            if scene.nextExperimentNode != nil {
                if CGRect(x: scene.nextExperimentNode!.position.x - 30, y: scene.nextExperimentNode!.position.y - 30, width: 60, height: 60).contains(positionInScene) {
                //if scene.nextExperimentNode!.containsPoint(positionInScene) {
                    inNextExperimentNode = true
                }
            }
            inTraceNode = scene.traceNode.calculateAccumulatedFrame().contains(positionInScene)
        }
        
        switch gestureRecognizer {
        case panGestureRecognizer:
            let velocity = panGestureRecognizer.velocity(in: self)
            verticalPan = abs(velocity.x) < abs(velocity.y)
            if inGameScene {
                if verticalPan {
                    return !inExperimentNode && !inNextExperimentNode
                } else {
                    return inRobotNode
                }
            } else {
                return true //verticalPan
            }
        case longPressGestureRecognizer:
            return inExperimentNode || inTraceNode
        case doubleTapGesture:
            return inGameScene && !inExperimentNode && !inNextExperimentNode && !inTraceNode && !inRobotNode
        default:
            return true
        }
    }
}
