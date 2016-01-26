//
//  SceneStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

struct GameStruct
{
    var experiment = ExperimentStruct()
    var experience = ExperienceStruct()
    
    let portraitSceneSize   = CGSize(width: 375, height: 667)
    let landscapeSceneSize  = CGSize(width: 1188, height: 667)
    let backgroundColor     = SKColor.lightGrayColor()
    let fontSize            = CGFloat(30)
    let titleFont           = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let bodyFont            = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
    let transitionOut       = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
    
    var experimentPositions = [CGPoint(x: 100, y: 100), CGPoint(x: 275, y: 100), CGPoint(x: 180, y: 100)]

    let experienceInterval  = CGPoint(x: 0, y: 50)
    let experiencePosition  = CGPoint(x: 187, y: 145)
    
    let valencePosition     = CGPoint(x: 50, y: -10)
    
    let actionScale         = SKAction.scaleTo(1, duration: 0.2)
    let actionMoveTrace     = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    
    let colorNodeRect       = CGRect(x: -30, y:-20, width: 60, height: 40)
    
    func moveByVect(point: CGPoint) -> CGVector {
        return CGVector(dx: 187 - point.x, dy: 190 - point.y)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = titleFont.fontName
        scoreLabel.fontSize = fontSize
        scoreLabel.verticalAlignmentMode = .Center
        return scoreLabel
    }
    
    func createScoreBackground() -> SKShapeNode {
        let scoreBackground = SKShapeNode(rect: CGRect(x: -30, y: -30, width: 60, height: 60), cornerRadius: 20)
        scoreBackground.position = CGPoint(x: 70, y: 580)
        scoreBackground.lineWidth = 0
        scoreBackground.name = "scoreBackground"
        scoreBackground.fillColor = UIColor.grayColor()
        return scoreBackground
    }
    
    func createHomeNode() -> SKShapeNode {
        let homeNode = SKShapeNode(rect: CGRect(x: -100, y: -15, width: 200, height: 30), cornerRadius: 0)
        homeNode.position = CGPoint(x: 90, y: 655)
        //homeNode.fillColor = UIColor.whiteColor()
        homeNode.lineWidth = 0
        homeNode.name = "home"
        return homeNode
    }
    
    func createShapePopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -160, y: -70, width: 320, height: 140), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 187, y: 250)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "shapePopup"
        return popupBackground
    }

    func createColorPopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -50, y: -200, width: 100, height: 400), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 100, y: 400)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "colorPopup"
        return popupBackground
    }

    
}
