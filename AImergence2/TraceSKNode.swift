//
//  TraceSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 25/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class TraceSKNode: SKNode {
    
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let actionMoveTrace = SKAction.moveBy(CGVector(dx:0, dy:100), duration: 0.3)
    let actionScale = SKAction.scaleTo(1, duration: 0.2)
    let disposedNode = SKLabelNode(text: NSLocalizedString("Disposed from memory", comment: "On top of the trace"))
    
    var eventNodes = Dictionary<Int, EventSKNode>()
    var bottomPosition = CGPointZero
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -40, y: 80)
        actionMoveTrace.timingMode = .EaseInEaseOut
        
        disposedNode.fontName = bodyFont.fontName
        disposedNode.fontSize = bodyFont.pointSize * 2
        disposedNode.verticalAlignmentMode = .Center
        disposedNode.fontColor = UIColor.whiteColor()
        disposedNode.hidden = true
        addChild(disposedNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEvent(clock: Int, eventNode: EventSKNode)
    {
        addChild(eventNode)
        eventNodes.updateValue(eventNode, forKey: clock)
        
        let moveInVector = CGVector(dx: bottomPosition.x - eventNode.position.x, dy: bottomPosition.y - eventNode.position.y)
        let actionIntroduce = SKAction.moveBy(moveInVector, duration: 0.3)
        eventNode.experienceNode.runAction(actionScale)
        eventNode.runAction(actionIntroduce, completion: {eventNode.addValenceNode()})
        runAction(actionMoveTrace)

        let removedEventNode = eventNodes.removeValueForKey(clock - eventNode.gameModel.obsolescence)
        if removedEventNode != nil {
            disposedNode.position = removedEventNode!.position
            removedEventNode!.removeFromParent()
            disposedNode.hidden = false
        }
        
        bottomPosition = bottomPosition + CGVector(dx: 0, dy: -100)
    }

    func dispose(clock: Int) {
        var lastPosition = CGPointZero
        for eventClock in eventNodes.keys {
            if eventClock < clock - 10 {
                let removedEventNode = eventNodes.removeValueForKey(eventClock)
                removedEventNode!.removeFromParent()
                if removedEventNode!.position.y < lastPosition.y {
                    lastPosition = removedEventNode!.position
                }
            }
        }
        if lastPosition.y < 0 {
            disposedNode.position = lastPosition
            disposedNode.hidden = false
        }
    }
}