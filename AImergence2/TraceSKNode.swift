//
//  TraceSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 25/07/16.
//  CC0 No rights reserved.
//
//  The node that contains all the EventNodes of the trace. 

import SpriteKit

class TraceSKNode: SKNode {
    
    let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    let actionMoveTrace = SKAction.move(by: CGVector(dx:0, dy:100), duration: 0.3)
    let actionScale = SKAction.scale(to: 1, duration: 0.2)
    let disposedNode = SKLabelNode(text: NSLocalizedString("Disposed from memory", comment: "On top of the trace"))
    
    var eventNodes = Dictionary<Int, EventSKNode>()
    var bottomPosition = CGPoint.zero
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -40, y: 80)
        actionMoveTrace.timingMode = .easeInEaseOut
        
        disposedNode.fontName = bodyFont.fontName
        disposedNode.fontSize = bodyFont.pointSize * 2
        disposedNode.verticalAlignmentMode = .center
        disposedNode.fontColor = UIColor.white
        disposedNode.isHidden = true
        addChild(disposedNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEvent(_ clock: Int, eventNode: EventSKNode)
    {
        addChild(eventNode)
        eventNodes.updateValue(eventNode, forKey: clock)
        
        let moveInVector = CGVector(dx: bottomPosition.x - eventNode.position.x, dy: bottomPosition.y - eventNode.position.y)
        let actionIntroduce = SKAction.move(by: moveInVector, duration: 0.3)
        eventNode.experienceNode.run(actionScale)
        eventNode.run(actionIntroduce, completion: {eventNode.addValenceNode()})
        run(actionMoveTrace)

        let removedEventNode = eventNodes.removeValue(forKey: clock - eventNode.gameModel.obsolescence)
        if removedEventNode != nil {
            disposedNode.position = removedEventNode!.position
            removedEventNode!.removeFromParent()
            disposedNode.isHidden = false
        }
        
        bottomPosition = bottomPosition + CGVector(dx: 0, dy: -100)
    }

    func dispose(_ clock: Int) {
        print("disposing SKnodes due to memory warning")
        var lastPosition = CGPoint.zero
        for eventClock in eventNodes.keys {
            if eventClock < clock - 10 {
                let removedEventNode = eventNodes.removeValue(forKey: eventClock)
                removedEventNode!.removeFromParent()
                if removedEventNode!.position.y < lastPosition.y {
                    lastPosition = removedEventNode!.position
                }
            }
        }
        if lastPosition.y < 0 {
            disposedNode.position = lastPosition
            disposedNode.isHidden = false
        }
    }
}
