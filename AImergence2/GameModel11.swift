//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel11: GameModel1
{
    override var shapePopupRect: CGRect {  return CGRect(x: -330, y: -300, width: 660, height: 400)}
    override var shapeRect: CGRect { return CGRect(x: -60, y: -60, width: 120, height: 120)}
    override var shapeOrigin: CGPoint { return CGPoint(x: -240, y: -200)}
    override var shapeOffset: CGVector { return CGVector(dx: 160, dy: 200)}
    override var shapePopupPosition: CGPoint { return CGPoint(x: 0, y: 440)}
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -100, y: -100, width: 200, height: 200)
        let experimentPositions = [CGPoint(x: -230, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 230, y: 0)]
        let experienceRect = CGRect(x: -40, y: -40, width: 80, height: 80)
        let initialScale = CGFloat(100)/40
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)}, halfCircleLeft, triangle, halfCircleRight, triangleUp, trapezoidLeft, {UIBezierPath(rect: $0)}, trapezoidRight]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]
        let sounds = [[11, 8], [12, 8], [10, 2], [6 ,1]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
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

func halfCircleLeft(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.addArcWithCenter(CGPoint(), radius: rect.maxX, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: true)
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.closePath()
    return path
}

func halfCircleRight(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.addArcWithCenter(CGPoint(), radius: rect.maxX, startAngle: CGFloat(M_PI) / 2 , endAngle: -CGFloat(M_PI) / 2, clockwise: false)
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.closePath()
    return path
}