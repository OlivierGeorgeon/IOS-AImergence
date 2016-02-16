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
    
    static let maxLevelNumber = 7
    
    static let portraitSize              = CGSize(width: 375, height: 667)
    static let landscapeSize             = CGSize(width: 1188, height: 667)
    static let portraitCameraPosition    = CGPoint(x: 0, y: 233)
    static let landscapeCameraPosition   = CGPoint(x: 400, y: 233)
    
    static let actionMoveCameraUp        = SKAction.moveBy(CGVector(dx:0, dy:667), duration: 0.3)
    static let actionMoveCameraDown      = SKAction.moveBy(CGVector(dx:0, dy:-667), duration: 0.3)
    static let actionMoveCameraDownUp    = SKAction.sequence([SKAction.moveBy(CGVector(dx:0, dy:-50), duration: 0.1), SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.1)])
    static let actionMoveCameraLeftRight = SKAction.sequence([SKAction.moveBy(CGVector(dx:-50, dy:0), duration: 0.1), SKAction.moveBy(CGVector(dx:50, dy:0), duration: 0.1)])
    static let actionMoveCameraRightLeft = SKAction.sequence([SKAction.moveBy(CGVector(dx:50, dy:0), duration: 0.1), SKAction.moveBy(CGVector(dx:-50, dy:0), duration: 0.1)])

    static let transitionUp    = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
    static let transitionDown  = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
    static let transitionLeft  = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5)
    static let transitionRight = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5)
    
    static let titleFont      = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    
    func positionInFrame(frameSize: CGSize) {
        if frameSize.height < frameSize.width {
            self.size = PositionedSKScene.landscapeSize
            camera?.position =  PositionedSKScene.landscapeCameraPosition
        } else {
            self.size = PositionedSKScene.portraitSize
            camera?.position =  PositionedSKScene.portraitCameraPosition
        }
    }
}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func * (left: Int, right: CGVector) -> CGVector {
    return CGVector(dx: CGFloat(left) * right.dx, dy: CGFloat(left) * right.dy) }

func += (inout left: CGPoint, right: CGVector) {left = left + right }