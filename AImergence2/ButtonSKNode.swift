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
    let actionPulse: SKAction
    let actionDisappear: SKAction
    
    let activatedTexture: SKTexture
    let disactivatedTexture: SKTexture

    var visible = false
    var active = true
    var pulsing = false
    
    init(activatedImageNamed: String, disactivatedImageNamed: String, active: Bool = true, pulsing: Bool = false)
    {
        self.activatedTexture = SKTexture(imageNamed: activatedImageNamed)
        self.disactivatedTexture = SKTexture(imageNamed: disactivatedImageNamed)
        self.active = active
        self.pulsing = pulsing
        let texture = active ? self.activatedTexture : self.disactivatedTexture
        
        let appearPath = UIBezierPath()
        //appearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: -CGFloat(M_PI) / 2 , endAngle: CGFloat(M_PI) / 2, clockwise: false)
        appearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: -CGFloat(M_PI) / 2 , endAngle: CGFloat(M_PI) / 2, clockwise: true)
        let actionAppearPath = SKAction.followPath(appearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        let actionAppearScale   = SKAction.scaleTo(0.9, duration: 0.2)
        actionAppear = SKAction.group([actionAppearScale, actionAppearPath])

        let actionPulseUp = SKAction.scaleTo(1, duration: 0.5)
        let actionPulseDown = SKAction.scaleTo(0.9, duration: 0.5)
        actionPulse = SKAction.repeatActionForever(SKAction.sequence([actionPulseUp, actionPulseDown]))

        let disappearPath = UIBezierPath()
        disappearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: true)
        let actionDisappearPath = SKAction.followPath(disappearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        let actionDisappearScale   = SKAction.scaleTo(0.0, duration: 0.2)
        actionDisappear = SKAction.group([actionDisappearPath, actionDisappearScale])

        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 76, height: 76))
        
        setScale(0.0)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appear() {
        if !visible {
            removeActionForKey("appearing")
            if pulsing {
                runAction(SKAction.sequence([actionAppear, actionPulse]), withKey: "appearing")
            } else {
                runAction(actionAppear, withKey: "appearing")
            }
            visible = true
        }
    }
    
    func disappear() {
        if visible {
            removeAllActions()
            runAction(actionDisappear)
            visible = false
        }
    }
    
    func activate() {
        active = true
        texture = activatedTexture
    }
    
    func disactivate() {
        active = false
        texture = disactivatedTexture
    }
    
    func pulse() {
        pulsing = true
        if visible {
            runAction(actionPulse)
        }
    }
    
    func unpulse() {
        pulsing = false
        removeAllActions()
    }
}