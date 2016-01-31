//
//  HomeStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

struct HomeStruct
{
    let portraitSceneSize   = CGSize(width: 375, height: 667)
    let landscapeSceneSize  = CGSize(width: 1188, height: 667)
    let backgroundColor     = SKColor.whiteColor()
    let fontSize            = CGFloat(30)
    let numberOfLevels      = 4
    let transitionOut       = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
    let titleFont            = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    
    let level0Position      = CGPoint(x: 187, y: 600)
    let levelOffsetVector   = CGVector( dx: 0, dy: -80)
    
    let cancelPosition      = CGPoint(x: 187, y: 100)

    func createLabelNode(text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize
        labelNode.fontColor = UIColor.whiteColor()
        labelNode.verticalAlignmentMode = .Center
        return labelNode
    }

    func createBackgroundNode() -> SKShapeNode {
        let backgroundNode = SKShapeNode(rect: CGRect(x: -100, y: -20, width: 200, height: 40), cornerRadius: 20)
        backgroundNode.fillColor = UIColor.lightGrayColor()
        backgroundNode.lineWidth = 0
        return backgroundNode
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
            level = Level2()
        case 3:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level3()
        case 4:
            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
            level = Level4()
        default:
            level = Level0()
        }
        return GameScene(level: level, gameStruct: gameStruct)
    }

}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy) }

func += (inout left: CGPoint, right: CGVector) {left = left + right }


