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
    static let numberOfLevels = 7

    let portraitSceneSize   = CGSize(width: 375, height: 667)
    let landscapeSceneSize  = CGSize(width: 1188, height: 667)
    let backgroundColor     = SKColor.whiteColor()
    let fontSize            = CGFloat(30)
    let transitionOut       = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
    let titleFont            = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    
    let level0Position      = CGPoint(x: 60, y: 540)
    let levelXOffset        = CGVector( dx: 60, dy: 0)
    let levelYOffset        = CGVector( dx:  0, dy: -80)
    
    let cancelPosition      = CGPoint(x: 187, y: 100)

    func createLabelNode(text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize
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

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func * (left: Int, right: CGVector) -> CGVector {
    return CGVector(dx: CGFloat(left) * right.dx, dy: CGFloat(left) * right.dy) }

func += (inout left: CGPoint, right: CGVector) {left = left + right }


