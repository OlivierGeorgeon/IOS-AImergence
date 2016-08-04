//
//  GameModel4.swift
//  Little AI
//
//  Created by Olivier Georgeon on 03/08/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class GameModel4: GameModel0
{
    required convenience init()
    {
        let experimentRect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let experimentPositions = [CGPoint(x: -90, y: 0), CGPoint(x: 90, y: 0), CGPoint(x: 0, y: 0)]
        let experienceRect = CGRect(x: -20, y: -20, width: 40, height: 40)
        let initialScale = CGFloat(120)/40
        let valencePosition = CGPoint(x: 50, y: -10)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]
        let sounds = [[9, 12], [11, 3], [2, 2]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }

}
