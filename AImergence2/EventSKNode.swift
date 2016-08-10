//
//  EventSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 19/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class EventSKNode: SKNode
{
    let frameNode =  SKShapeNode(rect: CGRect(origin: CGPoint(x:-40, y:-23), size: CGSize(width: 140, height: 46)), cornerRadius: 23)
    let pressAction = SKAction.sequence([SKAction.unhide(), SKAction.waitForDuration(0.1), SKAction.hide()])
    let gameModel: GameModel0
    let valence: Int
    let experienceNode: ExperienceSKNode
    
    init(experience:Experience, gameModel: GameModel0) {
        self.gameModel = gameModel
        self.valence = experience.valence
        self.experienceNode = ExperienceSKNode(experience: experience, gameModel: gameModel)
        super.init()
        self.frameNode.hidden = true
        self.frameNode.fillColor = UIColor(red: 200 / 256, green: 150 / 256, blue: 200 / 256, alpha: 1)
        self.frameNode.lineWidth = 0
        self.frameNode.zPosition = -2
        addChild(self.frameNode)
        addChild(self.experienceNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reshape() {
        experienceNode.reshape()
    }

    func refill() {
        experienceNode.refill()
    }
    
    func runPressAction() {
        self.frameNode.runAction(pressAction)
    }
    
    func addValenceNode()
    {
        let valenceNode = SKLabelNode()
        valenceNode.fontName = gameModel.titleFont.fontName
        valenceNode.fontSize = gameModel.titleFont.pointSize * 2
        valenceNode.position = gameModel.valencePosition
        valenceNode.text = "\(valence)"
        addChild(valenceNode)
        
        let absValence = abs(valence)
        let dotColor: UIColor
        if valence > 0 {
            dotColor = UIColor.greenColor()
        } else {
            dotColor = UIColor.redColor()
        }
        if absValence > 0 {
            let dotlines = min(absValence, 5)
            let maxDotIndex = absValence - 1
            let gaugeWidth = maxDotIndex / 5 * 16 + 20
            let gaugeHight = dotlines * 12 + 12
            let gaugeNode = SKShapeNode(rect: CGRect(x: -10, y: -gaugeHight / 2, width: gaugeWidth, height: gaugeHight), cornerRadius: 10)
            gaugeNode.position = CGPoint(x: 154, y: 0)
            gaugeNode.zPosition = -1
            gaugeNode.lineWidth = 2
            addChild(gaugeNode)
            for i in 0...maxDotIndex {
                let dotNode = SKShapeNode(rect: CGRect(x: i / 5 * 16 - 6, y: 6 * dotlines - i % 5 * 12 - 10, width: 12, height: 8))
                dotNode.fillColor = dotColor
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
    }
}