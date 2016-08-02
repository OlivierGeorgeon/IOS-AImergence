//
//  ButtonSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 08/06/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

enum BUTTON: Int { case INSTRUCTION, IMAGINE, LEADERBOARD}

class ButtonSKNode: SKNode
{
    let button: BUTTON
    let actionAppear: SKAction
    let actionAppearScale   = SKAction.scaleTo(0.9, duration: 0.2)
    let actionPulse: SKAction
    let actionDisappear: SKAction
    let actionDisappearScale   = SKAction.scaleTo(0.0, duration: 0.2)
    let actionExpand: SKAction
    let actionCollapse: SKAction
    let actionReduce: SKAction
    let backgroundNode: SKSpriteNode
    
    let activatedTexture: SKTexture
    let disactivatedTexture: SKTexture

    var active = true
    var pulsing = false
    
    init(_ button: BUTTON, activatedImageNamed: String, disactivatedImageNamed: String)
    {
        self.button = button
        self.activatedTexture = SKTexture(imageNamed: activatedImageNamed)
        self.disactivatedTexture = SKTexture(imageNamed: disactivatedImageNamed)
        self.backgroundNode = SKSpriteNode(texture: self.activatedTexture, color: UIColor.clearColor(), size: CGSize(width: 76, height: 76))
        
        let appearPath = UIBezierPath()
        appearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: -CGFloat(M_PI) / 2 , endAngle: CGFloat(M_PI) / 2, clockwise: true)
        actionAppear = SKAction.followPath(appearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        actionAppear.timingMode = .EaseOut
        actionAppearScale.timingMode = .EaseOut

        let actionFirstPulseUp = SKAction.scaleTo(1.5, duration: 0.3)
        actionFirstPulseUp.timingMode = .EaseInEaseOut
        let actionPulseDown = SKAction.scaleTo(0.9, duration: 0.3)
        actionPulseDown.timingMode = .EaseInEaseOut
        let actionPulseUp = SKAction.scaleTo(1, duration: 0.3)
        actionPulseUp.timingMode = .EaseInEaseOut
        actionPulse = SKAction.sequence([actionFirstPulseUp, SKAction.repeatActionForever(SKAction.sequence([actionPulseDown, actionPulseUp]))])

        let disappearPath = UIBezierPath()
        disappearPath.addArcWithCenter(CGPoint(x: 0, y: 60), radius: 30, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: true)
        actionDisappear = SKAction.followPath(disappearPath.CGPath, asOffset: false, orientToPath: false, duration: 0.2)
        actionDisappear.timingMode = .EaseIn
        actionDisappearScale.timingMode = .EaseIn
        
        switch button {
        case .INSTRUCTION:
            actionExpand = SKAction.moveTo(CGPoint(x: 0, y: 90 + 140), duration: 0.2)
        case .IMAGINE:
            actionExpand = SKAction.moveTo(CGPoint(x: 0, y: 90 + 70), duration: 0.2)
        case .LEADERBOARD:
            actionExpand = SKAction.moveTo(CGPoint(x: 0, y: 90), duration: 0.2)
        }
        actionExpand.timingMode = .EaseInEaseOut
        
        actionReduce = SKAction.moveTo(CGPoint(x: 0, y: 90), duration: 0.2)
        actionReduce.timingMode = .EaseInEaseOut
        
        actionCollapse = SKAction.moveTo(CGPointZero, duration: 0.2)
        actionCollapse.timingMode = .EaseIn
        
        super.init()
        
        addChild(backgroundNode)
        backgroundNode.setScale(0.0)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        removeActionForKey("expand")
        runAction(actionExpand, withKey: "expand")
        if position.y <= 0 {
            backgroundNode.runAction(actionAppearScale)
        }
    }
    
    func collapse() {
        //removeActionForKey("pulsing")
        removeActionForKey("expand")
        removeActionForKey("appearing")
        runAction(actionCollapse)
        backgroundNode.runAction(actionDisappearScale)
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
        backgroundNode.runAction(actionAppearScale)
        //if pulsing {
        //    backgroundNode.runAction(SKAction.sequence([actionPulse]), withKey: "pulsing")
        //}
    }
    
    func disappear() {
        removeActionForKey("expand")
        //removeActionForKey("pulsing")
        removeActionForKey("appearing")
        runAction(actionDisappear)
        backgroundNode.runAction(actionDisappearScale)
    }
    
    func activate() {
        active = true
        backgroundNode.texture = activatedTexture
    }
    
    func disactivate() {
        active = false
        backgroundNode.texture = disactivatedTexture
    }
    
    func pulse() {
        pulsing = true
        backgroundNode.runAction(actionPulse, withKey: "pulsing")
    }
    
    func unpulse() {
        pulsing = false
        backgroundNode.removeActionForKey("pulsing")
    }
}