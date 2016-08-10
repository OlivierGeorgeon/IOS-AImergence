//
//  PositionedSKScene.swift
//  AImergence
//
//  Created by Olivier Georgeon on 16/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class PositionedSKScene: SKScene {
    
    // Portrait:  scene width:  375, hight: 667
    // Landscape: scene width: 1186, hight: 667
    
    let sceneHeight = CGFloat(667)
    //let sceneHeight = CGFloat(1334)
    let actionPress = SKAction.sequence([SKAction.scaleBy(0.909, duration: 0.1),SKAction.scaleBy(1.1, duration: 0.1)])
    let transitionUp    = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.3)
    let transitionDown  = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.3)
    let transitionLeft  = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5)
    let transitionRight = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5)
    let titleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        positionInFrame(view.frame.size)
    }
    
    func positionInFrame(frameSize: CGSize) {
        self.size = CGSize(width: sceneHeight * frameSize.width / frameSize.height, height: sceneHeight)
    }
    
    func tap(recognizer: UITapGestureRecognizer) {}
    
    func longPress(recognizer: UILongPressGestureRecognizer) {}

    func pan(recognizer: UIPanGestureRecognizer) {}
}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func * (left: Int, right: CGVector) -> CGVector {
    return CGVector(dx: CGFloat(left) * right.dx, dy: CGFloat(left) * right.dy) }

func += (inout left: CGPoint, right: CGVector) {left = left + right }

prefix func - (point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}

