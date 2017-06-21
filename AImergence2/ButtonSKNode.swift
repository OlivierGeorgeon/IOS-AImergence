//
//  ButtonSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 08/06/16.
//  CC0 No rights reserved.
//
//  A button in the user interface 
//

import SpriteKit

enum BUTTON: Int { case instruction, imagine, leaderboard}

class ButtonSKNode: SKNode
{
    let button: BUTTON
    let actionAppear: SKAction
    let actionAppearScale   = SKAction.scale(to: 0.9, duration: 0.3)
    let actionPulse: SKAction
    let actionDisappear: SKAction
    let actionDisappearScale   = SKAction.scale(to: 0.0, duration: 0.3)
    let actionExpand: SKAction
    let actionCollapse: SKAction
    let actionReduce: SKAction
    let backgroundNode: SKSpriteNode
    
    let activatedTexture: SKTexture
    let disactivatedTexture: SKTexture

    var visible = false
    var active = true
    var pulsing = false
    
    init(_ button: BUTTON, activatedImageNamed: String, disactivatedImageNamed: String)
    {
        self.button = button
        self.activatedTexture = SKTexture(imageNamed: activatedImageNamed)
        self.disactivatedTexture = SKTexture(imageNamed: disactivatedImageNamed)
        self.backgroundNode = SKSpriteNode(texture: self.activatedTexture)
        
        let appearPath = UIBezierPath()
        appearPath.addArc(withCenter: CGPoint(x: 0, y: 90), radius: 90, startAngle: -CGFloat(Double.pi) / 2 , endAngle: CGFloat(Double.pi) / 2, clockwise: true)
        actionAppear = SKAction.follow(appearPath.cgPath, asOffset: false, orientToPath: false, duration: 0.3)
        actionAppear.timingMode = .easeOut
        actionAppearScale.timingMode = .easeOut

        let actionFirstPulseUp = SKAction.scale(to: 1.5, duration: 0.3)
        actionFirstPulseUp.timingMode = .easeInEaseOut
        let actionPulseDown = SKAction.scale(to: 0.9, duration: 0.3)
        actionPulseDown.timingMode = .easeInEaseOut
        let actionPulseUp = SKAction.scale(to: 1, duration: 0.3)
        actionPulseUp.timingMode = .easeInEaseOut
        actionPulse = SKAction.sequence([actionFirstPulseUp, SKAction.repeatForever(SKAction.sequence([actionPulseDown, actionPulseUp]))])

        let disappearPath = UIBezierPath()
        disappearPath.addArc(withCenter: CGPoint(x: 0, y: 90), radius: 90, startAngle: CGFloat(Double.pi) / 2 , endAngle: -CGFloat(Double.pi) / 2, clockwise: true)
        actionDisappear = SKAction.follow(disappearPath.cgPath, asOffset: false, orientToPath: false, duration: 0.3)
        actionDisappear.timingMode = .easeIn
        actionDisappearScale.timingMode = .easeIn
        
        switch button {
        case .instruction:
            actionExpand = SKAction.move(to: CGPoint(x: 0, y: 180 + 280), duration: 0.2)
        case .imagine:
            actionExpand = SKAction.move(to: CGPoint(x: 0, y: 180 + 140), duration: 0.2)
        case .leaderboard:
            actionExpand = SKAction.move(to: CGPoint(x: 0, y: 180), duration: 0.2)
        }
        actionExpand.timingMode = .easeInEaseOut
        
        actionReduce = SKAction.move(to: CGPoint(x: 0, y: 180), duration: 0.2)
        actionReduce.timingMode = .easeInEaseOut
        
        actionCollapse = SKAction.move(to: CGPoint.zero, duration: 0.2)
        actionCollapse.timingMode = .easeIn
        
        super.init()
        
        addChild(backgroundNode)
        backgroundNode.setScale(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        removeAction(forKey: "expand")
        run(actionExpand, withKey: "expand")
        if !visible && !pulsing  { // avoids saccade when already expanded
            backgroundNode.run(actionAppearScale)
        }
        visible = true
    }
    
    func collapse() {
        removeAction(forKey: "expand")
        removeAction(forKey: "appearing")
        run(actionCollapse)
        backgroundNode.run(actionDisappearScale)
        visible = false
    }

    func reduce() {
        removeAction(forKey: "expand")
        removeAction(forKey: "appearing")
        run(actionReduce)
        visible = true
    }
    
    func appear(instentaneous: Bool = false) {
        removeAction(forKey: "expand")
        removeAction(forKey: "appearing")
        if instentaneous {
            position = CGPoint(x: 0, y: 180)
        } else {
            run(actionAppear, withKey: "appearing")
        }
        if !visible && !pulsing {
            backgroundNode.run(actionAppearScale)
        }
        visible = true
    }
    
    func disappear() {
        removeAction(forKey: "expand")
        removeAction(forKey: "appearing")
        run(actionDisappear)
        backgroundNode.run(actionDisappearScale)
        visible = false
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
        backgroundNode.run(actionPulse, withKey: "pulsing")
    }
    
    func unpulse() {
        pulsing = false
        backgroundNode.removeAction(forKey: "pulsing")
    }
}
