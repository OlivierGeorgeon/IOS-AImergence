//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel1: GameModel0
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
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]

 //       let sound1 = SKAction.playSoundFileNamed("baby1.wav", waitForCompletion: false)
        let sound2 = SKAction.playSoundFileNamed("baby2.wav", waitForCompletion: false)
        let sound3 = SKAction.playSoundFileNamed("baby3.wav", waitForCompletion: false)
        let sound4 = SKAction.playSoundFileNamed("baby4.wav", waitForCompletion: false)
//        let sound5 = SKAction.playSoundFileNamed("baby5.wav", waitForCompletion: false)
        let sound6 = SKAction.playSoundFileNamed("baby6.wav", waitForCompletion: false)
//        let sound7 = SKAction.playSoundFileNamed("baby7.wav", waitForCompletion: false)
        let sound8 = SKAction.playSoundFileNamed("baby8.wav", waitForCompletion: false)
        let sound9 = SKAction.playSoundFileNamed("baby9.wav", waitForCompletion: false)
//        let sound10 = SKAction.playSoundFileNamed("baby10.wav", waitForCompletion: false)
//        let sound11 = SKAction.playSoundFileNamed("baby11.wav", waitForCompletion: false)
//        let sound12 = SKAction.playSoundFileNamed("baby12.wav", waitForCompletion: false)
        
        let sounds = [[sound6, sound8], [sound9, sound3], [sound2, sound4]]
        
        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors, sounds: sounds)
    }
}
