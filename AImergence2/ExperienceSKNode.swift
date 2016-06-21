//
//  ExperienceNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ExperienceSKNode: ReshapableSKNode
{
    let experience:Experience
    let stepOfCreation:Int

    override var shapeIndex:Int {return experience.shapeIndex }

    init(rect: CGRect, experience: Experience, stepOfCreation: Int, gameModel: GameModel) {
        self.experience = experience
        self.stepOfCreation = stepOfCreation
        super.init(rect: rect, gameModel: gameModel)
        reshape()
        lineWidth = 0
        refill()
        name = "experience_\(experience.hashValue)"
        setScale(gameModel.initialScale)
        zPosition = 1
    }
    
    convenience init(experience:Experience, stepOfCreation: Int, gameModel:GameModel2){
        self.init(rect: gameModel.experienceRect, experience: experience, stepOfCreation: stepOfCreation, gameModel: gameModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill() {
        fillColor = gameModel.experienceColors[experience.colorIndex]
    }
    
    func addValenceNode()
    {
        let valenceNode = SKLabelNode()
        valenceNode.fontName = gameModel.titleFont.fontName
        valenceNode.fontSize = gameModel.titleFont.pointSize
        valenceNode.position = gameModel.valencePosition
        valenceNode.text = "\(experience.valence)"
        addChild(valenceNode)
        
        let absValence = abs(experience.valence)
        let dotBackgroundNode = SKNode()
        dotBackgroundNode.zPosition = -1
        dotBackgroundNode.position = CGPoint(x: -40, y: -5 - 3 * absValence)
        addChild(dotBackgroundNode)
        if absValence > 0 {
            for i in 1...absValence {
                let dotNode = SKShapeNode(rect: CGRect(x: 0, y: i * 6, width: 6, height: 4))
                if experience.valence > 0 {
                    dotNode.fillColor = UIColor.greenColor()
                } else {
                    dotNode.fillColor = UIColor.redColor()
                }
                dotNode.lineWidth = 0
                dotBackgroundNode.addChild(dotNode)
            }
        }
    }
    
    func isObsolete(clock: Int) -> Bool {
        return clock - stepOfCreation > gameModel.obsolescence
    }
}
