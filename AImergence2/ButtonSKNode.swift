//
//  ButtonSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 08/06/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

enum BUTTON: Int { case INSTRUCTION, IMAGINE, LEADERBOARD}

class ButtonSKNode: SKSpriteNode
{
    let button: BUTTON
    let actionAppear: SKAction
    let actionPulse: SKAction
    let actionDisappear: SKAction
    let actionExpand: SKAction
    let actionCollapse: SKAction
    let actionReduce: SKAction
    
    let activatedTexture: SKTexture
    let disactivatedTexture: SKTexture

    var active = true
    var pulsing = false
    
    init(_ button: BUTTON, activatedImageNamed: String, disactivatedImageNamed: String)
    {
        self.button = button
        self.activatedTexture = SKTexture(imageNamed: activatedImageNamed)
        self.disactivatedTexture = SKTexture(imageNamed: disactivatedImageNamed)
        let texture = self.activatedTexture
        
        let appearPath = UIBezierPath()
        appearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: -CGFloat(M_PI) / 2 , endAngle: CGFloat(M_PI) / 2, clockwise: true)
        let actionAppearPath = SKAction.followPath(appearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        actionAppearPath.timingMode = .EaseOut
        let actionAppearScale   = SKAction.scaleTo(0.9, duration: 0.2)
        actionAppearScale.timingMode = .EaseOut
        actionAppear = SKAction.group([actionAppearScale, actionAppearPath])

        let actionFirstPulseUp = SKAction.scaleTo(1.5, duration: 0.3)
        actionFirstPulseUp.timingMode = .EaseInEaseOut
        let actionPulseDown = SKAction.scaleTo(0.9, duration: 0.3)
        actionPulseDown.timingMode = .EaseInEaseOut
        let actionPulseUp = SKAction.scaleTo(1, duration: 0.3)
        actionPulseUp.timingMode = .EaseInEaseOut
        actionPulse = SKAction.sequence([actionFirstPulseUp, SKAction.repeatActionForever(SKAction.sequence([actionPulseDown, actionPulseUp]))])

        let disappearPath = UIBezierPath()
        disappearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: true)
        let actionDisappearPath = SKAction.followPath(disappearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        actionDisappearPath.timingMode = .EaseIn
        let actionDisappearScale   = SKAction.scaleTo(0.0, duration: 0.2)
        actionDisappearScale.timingMode = .EaseIn
        actionDisappear = SKAction.group([actionDisappearPath, actionDisappearScale])
        
        let actionExpandUp : SKAction
        switch button {
        case .INSTRUCTION:
            actionExpandUp = SKAction.moveTo(CGPoint(x: 0, y: 90 + 140), duration: 0.2)
        case .IMAGINE:
            actionExpandUp = SKAction.moveTo(CGPoint(x: 0, y: 90 + 70), duration: 0.2)
        case .LEADERBOARD:
            actionExpandUp = SKAction.moveTo(CGPoint(x: 0, y: 90), duration: 0.2)
        }
        actionExpandUp.timingMode = .EaseInEaseOut
        actionExpand = SKAction.group([actionExpandUp, actionAppearScale])
        
        actionReduce = SKAction.moveTo(CGPoint(x: 0, y: 90), duration: 0.2)
        actionReduce.timingMode = .EaseInEaseOut
        
        let actionZero = SKAction.moveTo(CGPointZero, duration: 0.2)
        actionZero.timingMode = .EaseIn
        actionCollapse = SKAction.group([actionZero, actionDisappearScale])
        
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 76, height: 76))
        
        setScale(0.0)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        removeActionForKey("expand")
        runAction(actionExpand, withKey: "expand")
    }
    
    func collapse() {
        removeActionForKey("pulsing")
        removeActionForKey("expand")
        removeActionForKey("appearing")
        runAction(actionCollapse)
    }

    func reduce() {
        removeActionForKey("expand")
        removeActionForKey("appearing")
        runAction(actionReduce)
    }
    
    func appear() {
        removeActionForKey("expand")
        removeActionForKey("appearing")
        runAction(actionAppear, withKey: "appearing")
        if pulsing {
            runAction(SKAction.sequence([actionPulse]), withKey: "pulsing")
        }
    }
    
    func disappear() {
        removeActionForKey("expand")
        removeActionForKey("pulsing")
        removeActionForKey("appearing")
        runAction(actionDisappear)
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
        runAction(actionPulse, withKey: "pulsing")
    }
    
    func unpulse() {
        pulsing = false
        removeActionForKey("pulsing")
    }
}