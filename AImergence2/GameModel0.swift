//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel0
{
    let backgroundColor     = SKColor.lightGrayColor()
    let color               = UIColor.whiteColor()
    let titleFont           = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let colorNodeRect       = CGRect(x: -60, y:-60, width: 120, height: 120)
    
    let experimentRect: CGRect
    let experimentPaths: [(CGRect) -> UIBezierPath]
    let initialScale: CGFloat
    let valencePosition: CGPoint
    let obsolescence: Int
    let experienceColors: [UIColor]
    let experimentPositions: [CGPoint]
    let experienceRect: CGRect
    let actionScale: SKAction
    let sounds: [[Int]]
    
    var shapePopupRect: CGRect {  return CGRect(x: -330, y: -140, width: 660, height: 280)}
    var shapeRect: CGRect { return CGRect(x: -80, y: -80, width: 160, height: 160)}
    var shapeOrigin: CGPoint { return CGPoint(x: -200, y: 0)}
    var shapeOffset: CGVector { return CGVector(dx: 200, dy: 0)}
    var shapePopupPosition: CGPoint { return CGPoint(x: 0, y: 300)}

    var level: Level0!
    
    init(experimentRect: CGRect, experimentPositions: [CGPoint], experienceRect: CGRect, initialScale: CGFloat, valencePosition: CGPoint, obsolescence: Int, actionScale: SKAction, experimentPaths: [(CGRect) -> UIBezierPath], experienceColors: [UIColor],sounds: [[Int]]) {
        self.experimentRect = experimentRect
        self.experimentPaths = experimentPaths
        self.initialScale = initialScale
        self.valencePosition = valencePosition
        self.obsolescence = obsolescence
        self.experienceColors = experienceColors

        self.experimentPositions = experimentPositions
        self.experienceRect = experienceRect
        self.actionScale = actionScale
        
        self.sounds = sounds
    }
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -120, y: -120, width: 240, height: 240)
        let experimentPositions = [CGPoint(x: -180, y: 0), CGPoint(x: 180, y: 0), CGPoint(x: 0, y: 0)]
        let experienceRect = CGRect(x: -40, y: -40, width: 80, height: 80)
        let initialScale = CGFloat(120)/40
        let valencePosition = CGPoint(x: 100, y: -20)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]

        let sounds = [[7, 10], [9, 8], [2, 2]]

        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }    

    func moveByVect(point: CGPoint) -> CGVector {
        return CGVector(dx: -40 - point.x, dy: 180 - point.y)
    }
}

func triangle(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x:0, y: rect.minY))
    path.closePath()
    return path
}


