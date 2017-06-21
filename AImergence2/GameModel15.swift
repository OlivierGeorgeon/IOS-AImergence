//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  CC0 No rights reserved.
//
//  Defines the layout of the game scene
//

import SpriteKit

class GameModel15: GameModel13
{
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let experimentPositions = [CGPoint(x: -230, y: 40), CGPoint(x: 0, y: 40), CGPoint(x: 230, y: 40), CGPoint(x: -230, y: -100), CGPoint(x: 0, y: -100), CGPoint(x: 230, y: -100)]
        let experienceRect = CGRect(x: -40, y: -40, width: 80, height: 80)
        let initialScale = CGFloat(60)/40
        let obsolescence = 100
        let actionScale = SKAction.scale(to: 1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalIn: $0)}, halfCircleLeft, triangle, halfCircleRight, triangleUp, trapezoidLeft, {UIBezierPath(rect: $0)}, trapezoidRight]
        let experienceColors = [UIColor.white, UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.red, UIColor.blue, UIColor.orange]
        let sounds = [[11, 8], [13, 8], [7, 2], [6 ,1], [10 ,3], [9, 4]]
        //let sounds = [[11, 8], [9, 8], [2, 7], [6 ,1], [10 ,3]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }
}
