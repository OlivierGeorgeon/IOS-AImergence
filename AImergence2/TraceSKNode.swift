//
//  TraceSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 25/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class TraceSKNode: SKNode {
    
    let actionMoveTrace = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    let actionScale = SKAction.scaleTo(1, duration: 0.2)
    
    var eventNodes = Dictionary<Int, EventSKNode>()
    var bottomPosition = CGPointZero
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -20, y: 40)
        actionMoveTrace.timingMode = .EaseInEaseOut
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEvent(clock: Int, eventNode: EventSKNode)
    {
        for eventClock in eventNodes.keys {
            if eventClock < clock - eventNode.gameModel.obsolescence {
                eventNodes[clock]?.removeFromParent()
                eventNodes.removeValueForKey(eventClock)
            }
        }
        
        addChild(eventNode)
        eventNodes.updateValue(eventNode, forKey: clock)
        
        let moveInVector = CGVector(dx: bottomPosition.x - eventNode.position.x, dy: bottomPosition.y - eventNode.position.y)
        let actionIntroduce = SKAction.moveBy(moveInVector, duration: 0.3)
        eventNode.experienceNode.runAction(actionScale)
        eventNode.runAction(actionIntroduce, completion: {eventNode.addValenceNode()})
        runAction(actionMoveTrace)
        bottomPosition = bottomPosition + CGVector(dx: 0, dy: -50)
    }
}