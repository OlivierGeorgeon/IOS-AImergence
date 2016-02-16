//
//  HomeStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

struct HomeStruct
{
    let level0Position      = CGPoint(x: 60, y: 540)
    let levelXOffset        = CGVector( dx: 60, dy: 0)
    let levelYOffset        = CGVector( dx:  0, dy: -80)
    
    let cancelPosition      = CGPoint(x: 187, y: 100)

    func createLabelNode(text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = PositionedSKScene.titleFont.fontName
        labelNode.fontSize = PositionedSKScene.titleFont.pointSize
        labelNode.fontColor = UIColor.whiteColor()
        labelNode.verticalAlignmentMode = .Center
        return labelNode
    }

    func createBackgroundNode() -> SKShapeNode {
        let backgroundNode = SKShapeNode(rect: CGRect(x: -100, y: -20, width: 200, height: 40), cornerRadius: 20)
        backgroundNode.fillColor = UIColor.lightGrayColor()
        backgroundNode.lineWidth = 0
        return backgroundNode
    }

    func createLevelBackgroundNode() -> SKShapeNode {
        let backgroundNode = SKShapeNode(path: UIBezierPath(ovalInRect: CGRect(x: -20, y: -20, width: 40, height: 40)).CGPath)
        //(rect: CGRect(x: -100, y: -20, width: 200, height: 40), cornerRadius: 20)
        backgroundNode.fillColor = UIColor.lightGrayColor()
        backgroundNode.lineWidth = 0
        return backgroundNode
    }
    
}



