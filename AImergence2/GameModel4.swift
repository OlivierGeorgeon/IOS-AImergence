//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel4: GameModel3
{
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -50, y: -50, width: 100, height: 100)
        let experimentPositions = [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)]
        let experienceRect = CGRect(x: -20, y: -20, width: 40, height: 40)
        let initialScale = CGFloat(100)/40
        let valencePosition = CGPoint(x: 50, y: -10)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)}, halfCircleLeft, triangle, halfCircleRight, triangleUp, trapezoidLeft, {UIBezierPath(rect: $0)}, trapezoidRight]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]

        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors)
    }

    override func createShapePopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -165, y: -150, width: 330, height: 200), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 0, y: 220)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "shapePopup"
        return popupBackground
    }
    
    override func createShapeNodes(shapePopupNode: SKNode) -> [SKShapeNode] {
        var shapeNodes = [SKShapeNode]()
        for i in 0..<experimentPaths.count {
            let shapeNode = SKShapeNode(path: experimentPaths[i](CGRect(x: -30, y: -30, width: 60, height: 60)).CGPath)
            shapeNode.lineWidth = 3
            shapeNode.strokeColor = UIColor.grayColor()
            shapeNode.fillColor = UIColor.whiteColor()
            shapeNode.position = CGPoint(x: i % 4 * 80 - 120 , y: i / 4 * 100 - 100)
            shapePopupNode.addChild(shapeNode)
            shapeNodes.append(shapeNode)
        }
        return shapeNodes
    }
}

func triangleUp(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.addLineToPoint(CGPoint(x:0, y: rect.maxY))
    path.closePath()
    return path
}

func trapezoidLeft(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY * 0.7))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY * 0.7))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.closePath()
    return path
}

func trapezoidRight(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY * 0.7))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY * 0.7))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.closePath()
    return path
}

private func halfCircleLeft(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.addArcWithCenter(CGPoint(), radius: rect.maxX, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: true)
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.closePath()
    return path
}

private func halfCircleRight(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.addArcWithCenter(CGPoint(), radius: rect.maxX, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: false)
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.closePath()
    return path
}