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
    let gameModel: GameModel
    let valence: Int
    let experienceNode: ExperienceSKNode
    
    init(experience:Experience, gameModel:GameModel2) {
        self.gameModel = gameModel
        self.valence = experience.valence
        self.experienceNode = ExperienceSKNode(experience: experience, gameModel: gameModel)
        super.init()
        self.frameNode.hidden = true
        self.frameNode.fillColor = UIColor(red: 200 / 256, green: 150 / 256, blue: 200 / 256, alpha: 1) //UIColor(red: 114 / 256, green: 114 / 256, blue: 171 / 256, alpha: 1)
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
        valenceNode.fontSize = gameModel.titleFont.pointSize
        valenceNode.position = gameModel.valencePosition
        valenceNode.text = "\(valence)"
        addChild(valenceNode)
        
        let absValence = abs(valence)
        let gaugeBackgroundNode = SKShapeNode(rect: CGRect(x: -2, y: 2, width: 10, height: absValence * 6 + 6), cornerRadius: 5)
        gaugeBackgroundNode.zPosition = -1
        gaugeBackgroundNode.lineWidth = 1
        let dotBackgroundNode = SKNode()
        dotBackgroundNode.zPosition = -1
        dotBackgroundNode.position = CGPoint(x: 73, y: -5 - 3 * absValence)
        addChild(dotBackgroundNode)
        if absValence > 0 {
            dotBackgroundNode.addChild(gaugeBackgroundNode)
            for i in 1...absValence {
                let dotNode = SKShapeNode(rect: CGRect(x: 0, y: i * 6, width: 6, height: 4))
                if valence > 0 {
                    dotNode.fillColor = UIColor.greenColor()
                } else {
                    dotNode.fillColor = UIColor.redColor()
                }
                dotNode.lineWidth = 0
                dotBackgroundNode.addChild(dotNode)
            }
        }
    }
}