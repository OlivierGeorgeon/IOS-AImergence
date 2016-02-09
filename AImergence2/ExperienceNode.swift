//
//  ExperienceNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ExperienceNode: ReshapableNode
{
    static let actionRefill = SKAction.customActionWithDuration(0, actionBlock: changeColor)
    static let colors = [UIColor.whiteColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor()]
    
    let experience:Experience
    let stepOfCreation:Int
    let experienceStruct:ExperienceStruct

    override var rect:CGRect {return experienceStruct.rect}
    override var shapeIndex:Int {return experience.shapeIndex }

    init(experience:Experience, stepOfCreation: Int, experienceStruct:ExperienceStruct){
        self.experience = experience
        self.stepOfCreation = stepOfCreation
        self.experienceStruct = experienceStruct
        super.init()
        reshape()
        lineWidth = 0
        refill()
        name = "experience_\(experience.hashValue)"
        setScale(experienceStruct.initialScale)
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill() {
        fillColor = ExperienceNode.colors[experience.colorIndex]
    }
    
    func addValenceNode()
    {
        let valenceNode = SKLabelNode()
        valenceNode.fontName = experienceStruct.titleFont.fontName
        valenceNode.fontSize = experienceStruct.titleFont.pointSize
        valenceNode.position = experienceStruct.valencePosition
        valenceNode.text = "\(experience.valence)"
        addChild(valenceNode)
    }
    
    func isObsolete(clock: Int) -> Bool {
        return clock - stepOfCreation > experienceStruct.obsolescence
    }
}

func changeColor(node: SKNode, elapsedTime:CGFloat) -> Void {
    if let experienceNode = node as? ExperienceNode {
        experienceNode.refill()
    }
}

