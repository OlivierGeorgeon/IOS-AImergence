//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel5: GameModel4
{
    
    required convenience init()
    {
        let experimentRect = CGRect(x: -30, y: -30, width: 60, height: 60)
        let experimentPositions = [CGPoint(x: -120, y: 0), CGPoint(x: -40, y: 0), CGPoint(x: 40, y: 0), CGPoint(x: 120, y: 0)]
        let experienceRect = CGRect(x: -20, y: -20, width: 40, height: 40)
        let initialScale = CGFloat(60)/40
        let valencePosition = CGPoint(x: 50, y: -10)
        let obsolescence = 100
        let actionScale = SKAction.scaleTo(1, duration: 0.2)
        let experimentPaths = [{UIBezierPath(ovalInRect: $0)}, halfCircleLeft, triangle, halfCircleRight, triangleUp, trapezoidLeft, {UIBezierPath(rect: $0)}, trapezoidRight]
        let experienceColors = [UIColor.whiteColor(), UIColor(red: 0, green: 0.9, blue: 0, alpha: 1), UIColor.redColor(), UIColor.blueColor(), UIColor.orangeColor()]

        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors)
    }

    override func createExperimentNodes(scene: SKScene) -> [ExperimentSKNode] {
        var experimentNodes = [ExperimentSKNode]()
        for i in 0...3 {
            let experimentNode = ExperimentSKNode(gameModel: self, experiment: level.experiments[i])
            experimentNode.position = experimentPositions[i]
            scene.addChild(experimentNode)
            experimentNodes.append(experimentNode)
        }
        return experimentNodes
    }
}
