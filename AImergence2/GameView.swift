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

class GameView: SKView, UIGestureRecognizerDelegate {
    
    //let motionView = UIView()
    weak var delegate: GameViewDelegate?
    
    let doubleTapGesture = UITapGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    var verticalPan = false

    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
    }
    
    func addBehavior (){
        panGestureRecognizer.addTarget(self, action: #selector(GameView.pan(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.tap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameView.longPress(_:)))
        longPressGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(longPressGestureRecognizer)
        
        doubleTapGesture.addTarget(self, action: #selector(GameView.doubleTap(_:)))
        doubleTapGesture.enabled = true
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        /*
        // Set vertical effect
        let value = 200
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -value
        verticalMotionEffect.maximumRelativeValue = value
        
        // Set vertical effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        verticalMotionEffect.minimumRelativeValue = -value
        verticalMotionEffect.maximumRelativeValue = value
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        addSubview(motionView)
        motionView.addMotionEffect(group)
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
    
    func nextLevel() {
        if let nextScene = delegate?.nextLevelScene() {
            presentScene(nextScene, transition: PositionedSKScene.transitionLeft)
        }
    }

    func previousLevel() {
        if let previousScene = delegate?.previousLevelScene() {
            presentScene(previousScene, transition: PositionedSKScene.transitionRight)
        }
    }
    
    func doubleTap(gesture:UITapGestureRecognizer) {
        if let scene = scene as? GameSKScene {
            scene.doubleTap(gesture)
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let velocity = panGestureRecognizer.velocityInView(self)
            verticalPan = abs(velocity.x) < abs(velocity.y)
            if let scene = scene as? GameSKScene {
                let positionInScene = scene.convertPointFromView(gestureRecognizer.locationInView(self))
                if verticalPan {
                    for experimentNode in scene.experimentNodes.values {
                        if experimentNode.containsPoint(positionInScene){
                            return false
                        }
                    }
                    if scene.nextExperimentNode != nil {
                        if scene.nextExperimentNode!.containsPoint(positionInScene) {
                            return false
                        }
                    }
                    return true
                } else {
                    let positionInScreen = scene.cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: scene)
                    if scene.robotNode.containsPoint(positionInScreen) {
                        return true
                    } else {
                        return false
                    }
                }
            } else {
                if verticalPan {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return true
        }
    }
}