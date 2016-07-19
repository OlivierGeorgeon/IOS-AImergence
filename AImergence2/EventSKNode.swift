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
    let frameNode =  SKShapeNode(rect: CGRect(origin: CGPointZero, size: CGSize(width: 200, height: 40)))
    let gameModel: GameModel
    let valence: Int
    let experienceNode: ExperienceSKNode
    
    init(experience:Experience, gameModel:GameModel2) {
        self.gameModel = gameModel
        self.valence = experience.valence
        self.experienceNode = ExperienceSKNode(experience: experience, gameModel: gameModel)
        super.init()
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