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
    
    let transitionDown      = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
    let transitionLeft      = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5)
    let transitionRight     = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5)
    
    var experimentPositions = [CGPoint(x: 100, y: 100), CGPoint(x: 275, y: 100), CGPoint(x: 180, y: 100)]
 
    let experiencePosition  = CGPoint(x: 187, y: 145)
        
    let actionScale         = SKAction.scaleTo(1, duration: 0.2)
    let actionMoveTrace     = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    
    let colorNodeRect       = CGRect(x: -30, y:-30, width: 60, height: 60)
    
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
        let popupBackground = SKShapeNode(rect: CGRect(x: -50, y: -230, width: 100, height: 460), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 85, y: 400)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "colorPopup"
        return popupBackground
    }

    static func createGameScene(levelNumber: Int) -> GameScene {
        let level:Level0
        var gameStruct = GameStruct()
        switch levelNumber {
        case 0:
            level = Level0()
        case 1:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -60, y: -60, width: 120, height: 120))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(120)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 100, y: 100), CGPoint(x: 275, y: 100), CGPoint(x: 180, y: 100)])
            level = Level1()
        case 2:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level2()
        case 3:
            level = Level3()
        case 4:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level4()
        case 5:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level5()
        case 6,-1:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level6()
        default:
            level = Level0()
        }
        return GameScene(level: level, gameStruct: gameStruct)
    }

}
