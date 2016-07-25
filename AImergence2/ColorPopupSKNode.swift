//
//  ColorPopupSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 25/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ColorPopupSKNode: SKNode {
    
    let colorNodeRect = CGRect(x: -30, y:-30, width: 60, height: 60)
    let colorsNode = SKNode()
    let actionAppear: SKAction
    let disappearScale = SKAction.scaleTo(0, duration: 0.1)
    
    var colorNodes = [SKShapeNode]()
    var colorIndex = 0

    override init() {
        let appearMove = SKAction.moveTo(CGPoint(x: -100, y: 300), duration: 0.1)
        let appearScale = SKAction.scaleTo(1, duration: 0.1)
        actionAppear = SKAction.sequence([SKAction.unhide(), SKAction.group([appearMove, appearScale])])
        actionAppear.timingMode = .EaseOut
        
        super.init()

        zPosition = 10
        setScale(0)
        addChild(colorsNode)

        let popupBackground = SKShapeNode(rect: CGRect(x: -50, y: -225, width: 100, height: 460), cornerRadius: 10)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.name = "colorPopup"
        addChild(popupBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func createColorNodes(pathFunc: (CGRect) -> UIBezierPath, experienceColors: [UIColor], colorIndex: Int) {
        self.colorIndex = colorIndex
        colorsNode.removeAllChildren()
        colorNodes = [SKShapeNode]()
        for i in 0..<5 {
            let colorNode = SKShapeNode(path: pathFunc(colorNodeRect).CGPath)
            colorNode.fillColor = experienceColors[i]
            colorNode.strokeColor = UIColor.grayColor()
            if i == colorIndex {
                colorNode.lineWidth = 6
            } else {
                colorNode.lineWidth = 1
            }
            colorNode.zPosition = 1
            colorNode.position = CGPoint(x:0, y: i * 80 - 160)
            colorsNode.addChild(colorNode)
            colorNodes.append(colorNode)
        }
    }
    
    func revolve() {
        colorNodes[colorIndex].lineWidth = 1
        colorIndex += 1
        if colorIndex >= colorNodes.count {
            colorIndex = 0
        }
        colorNodes[colorIndex].lineWidth = 6
    }
}