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
    let colorNodeRect       = CGRect(x: -30, y:-30, width: 60, height: 60)
    let experimentRect: CGRect
    let experimentPaths: [(CGRect) -> UIBezierPath]
    let initialScale: CGFloat
    let valencePosition: CGPoint
    let obsolescence: Int
    let experienceColors: [UIColor]
    var shapePopupRect: CGRect {  return CGRect(x: -165, y: -70, width: 330, height: 140)}
    var shapeRect: CGRect { return CGRect(x: -40, y: -40, width: 80, height: 80)}
    var shapeOrigin: CGPoint { return CGPoint(x: -100, y: 0)}
    var shapeOffset: CGVector { return CGVector(dx: 100, dy: 0)}
    var shapePopupPosition: CGPoint { return CGPoint(x: 0, y: 150)}

    let experimentPositions: [CGPoint]
    let experienceRect: CGRect
    let actionScale: SKAction
    
    var level: Level0!
    
    init(experimentRect: CGRect, experimentPositions: [CGPoint], experienceRect: CGRect, initialScale: CGFloat, valencePosition: CGPoint, obsolescence: Int, actionScale: SKAction, experimentPaths: [(CGRect) -> UIBezierPath], experienceColors: [UIColor]) {
        self.experimentRect = experimentRect
        self.experimentPaths = experimentPaths
        self.initialScale = initialScale
        self.valencePosition = valencePosition
        self.obsolescence = obsolescence
        self.experienceColors = experienceColors

        self.experimentPositions = experimentPositions
        self.experienceRect = experienceRect
        self.actionScale = actionScale
        //super.init(experimentRect: experimentRect, experimentPaths: experimentPaths, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, experienceColors: experienceColors)
    }
    
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

        self.init(experimentRect: experimentRect, experimentPositions: experimentPositions, experienceRect: experienceRect, initialScale: initialScale, valencePosition: valencePosition, obsolescence: obsolescence, actionScale: actionScale, experimentPaths: experimentPaths, experienceColors: experienceColors)
    }    

    func moveByVect(point: CGPoint) -> CGVector {
        return CGVector(dx: -20 - point.x, dy: 90 - point.y)
    }
    
    /*
    func createExperimentNodes(scene: SKScene) -> Dictionary<Int, ExperimentSKNode> {
        var experimentNodes = Dictionary<Int, ExperimentSKNode>()
        for i in 0...1 {
            let experimentNode = ExperimentSKNode(gameModel: self, experiment: level.experiments[i])
            experimentNode.position = experimentPositions[i]
            scene.addChild(experimentNode)
            experimentNodes.updateValue(experimentNode, forKey: experimentNode.experiment.number)
        }
        return experimentNodes
    }*/
}

func triangle(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x:0, y: rect.minY))
    path.closePath()
    return path
}


