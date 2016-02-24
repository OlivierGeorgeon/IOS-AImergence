//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel0: GameModel
{

    let experimentRect: CGRect
    let experimentPositions: [CGPoint]
    let experienceRect: CGRect
    let initialScale: CGFloat
    let valencePosition: CGPoint
    let obsolescence: Int
    let actionScale: SKAction
    
    var level: Level0!
    
    init(experimentRect: CGRect, experimentPositions: [CGPoint], experienceRect: CGRect, initialScale: CGFloat, valencePosition: CGPoint, obsolescence: Int, actionScale: SKAction) {
        self.experimentRect = experimentRect
        self.experimentPositions = experimentPositions
        self.experienceRect = experienceRect
        self.initialScale = initialScale
        self.valencePosition = valencePosition
        self.obsolescence = obsolescence
        self.actionScale = actionScale
    }
    
    required override convenience init()
    {
        let experimentRect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let experimentPositions = [CGPoint(x: -90, y: 0), CGPoint(x: 90, y: 0), CGPoint(x: 0, y: 0)]
        let experienceRect = CGRect(x: -20, y: -20, width: 40, height: 40)
        let initialScale = CGFloat(120)/40
        let valencePosition = CGPoint(x: 50, y: -10)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale)
    }    
}
