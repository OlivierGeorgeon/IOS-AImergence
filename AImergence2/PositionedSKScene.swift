//
//  PositionedSKScene.swift
//  Little AI
//
//  Created by Olivier Georgeon on 16/02/16.
//  CC0 No rights reserved.
//
//  The parent scene from which the Game Scene and the Menu Scene inherit. 
//

import Foundation
import SpriteKit

class PositionedSKScene: SKScene {
    
    // Portrait:  scene width:  375, hight: 667
    // Landscape: scene width: 1186, hight: 667
    
    //let sceneHeight = CGFloat(667)
    let sceneHeight = CGFloat(1334)
    let actionPress = SKAction.sequence([SKAction.scale(by: 0.909, duration: 0.1),SKAction.scale(by: 1.1, duration: 0.1)])
    let transitionUp    = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 0.3)
    let transitionDown  = SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.3)
    let transitionLeft  = SKTransition.push(with: SKTransitionDirection.left, duration: 0.5)
    let transitionRight = SKTransition.push(with: SKTransitionDirection.right, duration: 0.5)
    let titleFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        positionInFrame(view.frame.size)
    }
    
    func positionInFrame(_ frameSize: CGSize) {
        self.size = CGSize(width: sceneHeight * frameSize.width / frameSize.height, height: sceneHeight)
    }
    
    func tap(_ recognizer: UITapGestureRecognizer) {}
    
    func longPress(_ recognizer: UILongPressGestureRecognizer) {}

    func pan(_ recognizer: UIPanGestureRecognizer) {}
}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func * (left: Int, right: CGVector) -> CGVector {
    return CGVector(dx: CGFloat(left) * right.dx, dy: CGFloat(left) * right.dy) }

func += (left: inout CGPoint, right: CGVector) {left = left + right }

prefix func - (point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}

