//
//  ButtonSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 08/06/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonSKNode: SKSpriteNode
{
    let actionAppear: SKAction
    let actionRepeatPulse: SKAction
    let actionDisappear: SKAction
    
    let activatedTexture: SKTexture
    let disactivatedTexture: SKTexture

    var activated = false
    
    init(activatedImageNamed: String, disactivatedImageNamed: String, activated: Bool) {
        activatedTexture = SKTexture(imageNamed: activatedImageNamed)
        disactivatedTexture = SKTexture(imageNamed: disactivatedImageNamed)
        self.activated = activated
        let appearPath = UIBezierPath()
        appearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: -CGFloat(M_PI) / 2 , endAngle: CGFloat(M_PI) / 2, clockwise: false)
        let actionAppearPath = SKAction.followPath(appearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        let actionScaleAppear   = SKAction.scaleTo(0.9, duration: 0.2)
        actionAppear = SKAction.group([actionScaleAppear, actionAppearPath])
        let actionPulseUp = SKAction.scaleTo(1, duration: 0.5)
        let actionPulseDown = SKAction.scaleTo(0.9, duration: 0.5)
        let actionPulse = SKAction.sequence([actionPulseUp, actionPulseDown])
        actionRepeatPulse = SKAction.repeatActionForever(actionPulse)
        let disappearPath = UIBezierPath()
        disappearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: false)
        let actionDisappearPath = SKAction.followPath(disappearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        let actionScaleDisappear   = SKAction.scaleTo(0.0, duration: 0.2)
        actionDisappear = SKAction.group([actionDisappearPath, actionScaleDisappear])
        let texture = activated ? self.activatedTexture : self.disactivatedTexture
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 76, height: 76))
        setScale(0.0)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appear() {
        removeAllActions()
        if activated {
            runAction(SKAction.sequence([actionAppear, actionRepeatPulse]))
        } else {
            runAction(actionAppear)
        }
    }
    
    func disappear() {
        removeAllActions()
        runAction(actionDisappear)
    }
    
    func activate() {
        activated = true
        texture = activatedTexture
    }
    
    func disactivate() {
        activated = false
        texture = disactivatedTexture
    }
}