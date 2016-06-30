//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameModel
{
    let backgroundColor     = SKColor.lightGrayColor()
    let color               = UIColor.whiteColor()
    let titleFont           = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let actionMoveTrace     = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    let colorNodeRect       = CGRect(x: -30, y:-30, width: 60, height: 60)
    
    let experimentRect: CGRect
    let experimentPaths: [(CGRect) -> UIBezierPath]
    let initialScale: CGFloat
    let valencePosition: CGPoint
    let obsolescence: Int
    let experienceColors: [UIColor]
    
    init(experimentRect: CGRect, experimentPaths: [(CGRect) -> UIBezierPath], initialScale: CGFloat, valencePosition: CGPoint, obsolescence: Int, experienceColors: [UIColor]) {
        self.experimentRect = experimentRect
        self.experimentPaths = experimentPaths
        self.initialScale = initialScale
        self.valencePosition = valencePosition
        self.obsolescence = obsolescence
        self.experienceColors = experienceColors
    }
    
    func moveByVect(point: CGPoint) -> CGVector { return CGVector(dx: -20 - point.x, dy: 90 - point.y) }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = titleFont.fontName
        scoreLabel.fontSize = titleFont.pointSize
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.fontColor = UIColor.darkGrayColor()// blackColor()
        return scoreLabel
    }
    
    func createScoreBackground() -> SKShapeNode {
        let scoreBackground = SKShapeNode(rect: CGRect(x: -30, y: -30, width: 60, height: 60), cornerRadius: 20)
        scoreBackground.position = CGPoint(x: -117, y: 502)
        scoreBackground.lineWidth = 0
        scoreBackground.name = "scoreBackground"
        scoreBackground.fillColor = UIColor.whiteColor()
        return scoreBackground
    }
    
    func createShapePopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -165, y: -70, width: 330, height: 140), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 0, y: 150)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "shapePopup"
        return popupBackground
    }

    func createShapeNodes(shapePopupNode: SKNode) -> [SKShapeNode] {
        var shapeNodes = [SKShapeNode]()
        for i in 0..<3 {
            let shapeNode = SKShapeNode(path: experimentPaths[i](CGRect(x: -40, y: -40, width: 80, height: 80)).CGPath)
            shapeNode.lineWidth = 3
            shapeNode.strokeColor = UIColor.grayColor()
            shapeNode.fillColor = UIColor.whiteColor()
            shapeNode.position = CGPoint(x: i * 100 - 100 , y: 0)
            shapePopupNode.addChild(shapeNode)
            shapeNodes.append(shapeNode)
        }
        return shapeNodes
    }

    func createColorPopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -50, y: -228, width: 100, height: 460), cornerRadius: 10)
        popupBackground.position = CGPoint(x: -100, y: 300)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "colorPopup"
        return popupBackground
    }
    
    func createColorNodes(colorPopupNode: SKNode, experience: Experience) -> [SKShapeNode] {
        var colorNodes = [SKShapeNode]()
        for i in 0..<5 {
            //let colorNode = SKShapeNode(rect: colorNodeRect)
            let colorNode = SKShapeNode(path: experimentPaths[experience.experiment.shapeIndex](colorNodeRect).CGPath)
            colorNode.fillColor = experienceColors[i]
            colorNode.strokeColor = UIColor.grayColor()
            colorNode.lineWidth = 1
            colorNode.position = CGPoint(x:0, y: i * 80 - 160)
            colorPopupNode.addChild(colorNode)
            colorNodes.append(colorNode)
        }
        return colorNodes
    }
    
    class func createGameModel(levelNumber: Int) -> GameModel2 {
        var level = Level0()
        
        // Not working since the app has been renamed Little AI
        //let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let aClass:AnyClass? =  NSClassFromString("Little_AI.Level\(levelNumber)")
        if let levelType = aClass as? Level0.Type
            { level = levelType.init() }

        var gameModel = GameModel2()
        let gameModelString = level.gameModelString
        let aClass2:AnyClass? =  NSClassFromString("Little_AI." + gameModelString)
        if let gameModelType = aClass2 as? GameModel2.Type {
            gameModel = gameModelType.init()
        }
        
        gameModel.level = level
        return gameModel
    }
}
