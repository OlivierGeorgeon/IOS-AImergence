//
//  ShapePopupSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 25/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class ShapePopupSKNode: SKNode {

    let popupBackground: SKShapeNode
    let actionAppear: SKAction
    let disappearScale = SKAction.scaleTo(0, duration: 0.1)

    var shapeNodes = [SKShapeNode]()
    var shapeIndex = 0

    init(gameModel: GameModel0) {
        popupBackground = SKShapeNode(rect: gameModel.shapePopupRect, cornerRadius: 0)
        let appearMove = SKAction.moveTo(gameModel.shapePopupPosition, duration: 0.1)
        let appearScale = SKAction.scaleTo(1, duration: 0.1)
        actionAppear = SKAction.sequence([SKAction.unhide(), SKAction.group([appearMove, appearScale])])
        actionAppear.timingMode = .EaseOut

        super.init()

        zPosition = 10
        setScale(0)

        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        popupBackground.name = "shapePopup"
        addChild(popupBackground)
        
        for i in 0..<gameModel.experimentPaths.count {
            let shapeNode = SKShapeNode(path: gameModel.experimentPaths[i](gameModel.shapeRect).CGPath)
            shapeNode.lineWidth = 6
            shapeNode.zPosition = 1
            shapeNode.lineJoin = .Round
            shapeNode.strokeColor = UIColor.grayColor()
            shapeNode.fillColor = UIColor.whiteColor()
            if gameModel.shapeOffset.dy == 0 {
                shapeNode.position = CGPoint(x: Int(gameModel.shapeOrigin.x) + i * Int(gameModel.shapeOffset.dx), y: 0)
            } else {
                shapeNode.position = CGPoint(x: Int(gameModel.shapeOrigin.x) + i % 4 * Int(gameModel.shapeOffset.dx), y: Int(gameModel.shapeOrigin.y) + i / 4 * Int(gameModel.shapeOffset.dy))
            }
            addChild(shapeNode)
            shapeNodes.append(shapeNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(shapeIndex: Int) {
        self.shapeIndex = shapeIndex
        shapeNodes.forEach({$0.lineWidth = 6})
        shapeNodes[shapeIndex].lineWidth = 12
    }
    
    func revolve() {
        shapeNodes[shapeIndex].lineWidth = 6
        shapeIndex += 1
        if shapeIndex >= shapeNodes.count {
            shapeIndex = 0
        }
        shapeNodes[shapeIndex].lineWidth = 12
    }

    func appear() {
        runAction(actionAppear)
    }
    
    func disappear(position: CGPoint) {
        let disappearMove = SKAction.moveTo(position, duration: 0.1)
        let actionDisappear = SKAction.sequence([SKAction.group([disappearMove, disappearScale]), SKAction.hide()])
        actionDisappear.timingMode = .EaseIn
        runAction(actionDisappear)
    }
}