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
    
    let backgroundColor     = SKColor.lightGrayColor()
    let titleFont           = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    //let bodyFont            = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
    
    var experimentPositions = [CGPoint(x: -90, y: 0), CGPoint(x: 90, y: 0), CGPoint(x: 0, y: 0)]
 
    let actionScale         = SKAction.scaleTo(1, duration: 0.2)
    let actionMoveTrace     = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    
    let colorNodeRect       = CGRect(x: -30, y:-30, width: 60, height: 60)
    
    func moveByVect(point: CGPoint) -> CGVector { return CGVector(dx: -point.x, dy: 90 - point.y) }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = titleFont.fontName
        scoreLabel.fontSize = titleFont.pointSize
        scoreLabel.verticalAlignmentMode = .Center
        return scoreLabel
    }
    
    func createScoreBackground() -> SKShapeNode {
        let scoreBackground = SKShapeNode(rect: CGRect(x: -30, y: -30, width: 60, height: 60), cornerRadius: 20)
        scoreBackground.position = CGPoint(x: -117, y: 480)
        scoreBackground.lineWidth = 0
        scoreBackground.name = "scoreBackground"
        scoreBackground.fillColor = UIColor.grayColor()
        return scoreBackground
    }
    
    func createShapePopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -160, y: -70, width: 320, height: 140), cornerRadius: 10)
        popupBackground.position = CGPoint(x: 0, y: 150)
        popupBackground.lineWidth = 0
        popupBackground.fillColor = UIColor.whiteColor()
        popupBackground.zPosition = 10
        popupBackground.name = "shapePopup"
        return popupBackground
    }

    func createColorPopup() -> SKShapeNode {
        let popupBackground = SKShapeNode(rect: CGRect(x: -50, y: -230, width: 100, height: 460), cornerRadius: 10)
        popupBackground.position = CGPoint(x: -100, y: 300)
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
            level = Level1()
        case 2:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)])
            level = Level2()
        case 3:
            level = Level3()
        case 4:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)])
            level = Level4()
        case 5:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)])
            level = Level5()
        case 6:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)])
            level = Level6()
        case 7:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: -115, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 115, y: 0)])
            level = Level7()
        default:
            level = Level0()
        }
        return GameScene(level: level, gameStruct: gameStruct)
    }

}
