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
    
    let sceneHeight = CGFloat(667)
    
    static let portraitCameraPosition    = CGPoint(x: 0, y: 233)
    static let portraitRobotPosition     = CGPoint(x: 120, y: 180)
    static let portraitRobotSize         = CGSize(width: 100, height: 100)
    //static let portraitButtonPosition    = CGPoint(x: 120, y: 280)
    //static let portraitButtonSize        = CGSize(width: 76, height: 76)

    //static let landscapeSize             = CGSize(width: 1188, height: 667)
    static let landscapeCameraPosition   = CGPoint(x: 400, y: 233)
    static let landscapeRobotPosition    = CGPoint(x: 700, y: 100)
    
    static let actionMoveCameraUp        = SKAction.moveBy(CGVector(dx:0, dy:667), duration: 0.3)
    static let actionMoveCameraDown      = SKAction.moveBy(CGVector(dx:0, dy:-667), duration: 0.3)
    static let actionMoveCameraDownUp    = SKAction.sequence([SKAction.moveBy(CGVector(dx:0, dy:-50), duration: 0.1), SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.1)])
    static let actionMoveCameraLeftRight = SKAction.sequence([SKAction.moveBy(CGVector(dx:-50, dy:0), duration: 0.1), SKAction.moveBy(CGVector(dx:50, dy:0), duration: 0.1)])
    static let actionMoveCameraRightLeft = SKAction.sequence([SKAction.moveBy(CGVector(dx:50, dy:0), duration: 0.1), SKAction.moveBy(CGVector(dx:-50, dy:0), duration: 0.1)])
    
    let actionPress = SKAction.sequence([SKAction.scaleTo(0.92, duration: 0.1),SKAction.scaleTo(1, duration: 0.1)])

    static let transitionUp    = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 0.5)
    static let transitionDown  = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
    static let transitionLeft  = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5)
    static let transitionRight = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5)
    
    static let titleFont      = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    static let bodyFont       = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    
    var cameraNode: SKCameraNode?
    var cameraRelativeOriginNode = SKNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        positionInFrame(view.frame.size)
    }
    
    func positionInFrame(frameSize: CGSize) {
        self.size = CGSize(width: sceneHeight * frameSize.width / frameSize.height, height: sceneHeight)
    }
}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func * (left: Int, right: CGVector) -> CGVector {
    return CGVector(dx: CGFloat(left) * right.dx, dy: CGFloat(left) * right.dy) }

func += (inout left: CGPoint, right: CGVector) {left = left + right }

prefix func - (point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}

