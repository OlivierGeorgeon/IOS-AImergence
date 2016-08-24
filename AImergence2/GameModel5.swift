//
//  GameModel5.swift
//  Little AI
//
//  Created by Olivier Georgeon on 03/08/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel5: GameModel0
{
    required convenience init()
    {
        let experimentRect = CGRect(x: -100, y: -100, width: 200, height: 200)
        let experimentPositions = [CGPoint(x: -230, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 230, y: 0)]
        let experienceRect = CGRect(x: -40, y: -40, width: 80, height: 80)
        let initialScale = CGFloat(100)/40
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]
        //let sounds = [[11, 10], [13, 3], [2, 1]]
        let sounds = [[11, 10], [13, 3], [1, 2]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }
}
