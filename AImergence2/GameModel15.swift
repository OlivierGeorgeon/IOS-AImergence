//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel15: GameModel13
{
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -30, y: -30, width: 60, height: 60)
        let experimentPositions = [CGPoint(x: -115, y: 20), CGPoint(x: 0, y: 20), CGPoint(x: 115, y: 20), CGPoint(x: -115, y: -50), CGPoint(x: 0, y: -50), CGPoint(x: 115, y: -50)]
        let experienceRect = CGRect(x: -20, y: -20, width: 40, height: 40)
        let initialScale = CGFloat(60)/40
        let valencePosition = CGPoint(x: 50, y: -10)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)}, halfCircleLeft, triangle, halfCircleRight, triangleUp, trapezoidLeft, {UIBezierPath(rect: $0)}, trapezoidRight]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]
        let sounds = [[11, 8], [13, 8], [7, 2], [6 ,1], [10 ,3], [9, 4]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }
}
