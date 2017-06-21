//
//  ExperienceNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/01/16.
//  CC0 No rights reserved.
//
//  A node that displays an interaction (Experience)
//

import SpriteKit

class ExperienceSKNode: ReshapableSKNode
{
    let experience:Experience

    override var shapeIndex:Int {return experience.shapeIndex }

    init(rect: CGRect, experience: Experience, gameModel: GameModel0) {
        self.experience = experience
        super.init(rect: rect, gameModel: gameModel)
        reshape()
        //lineWidth = 0
        refill()
        name = "experience_\(experience.hashValue)"
        zPosition = 1
    }
    
    convenience init(experience:Experience, gameModel: GameModel0){
        self.init(rect: gameModel.experienceRect, experience: experience, gameModel: gameModel)
        setScale(gameModel.initialScale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill() {
        fillColor = gameModel.experienceColors[experience.colorIndex]
        strokeColor = gameModel.experienceColors[experience.colorIndex]
    }    
}
