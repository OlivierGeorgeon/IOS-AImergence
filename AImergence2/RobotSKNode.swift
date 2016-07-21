//
//  RobotSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 21/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

enum RECOMMEND: Int { case INSTRUCTION, INSTRUCTION_OK, IMAGINE, LEADERBOARD, DONE}

class RobotSKNode: SKNode
{
    let imageNode = SKSpriteNode(imageNamed: "happy1")
    let instructionButtonNode = ButtonSKNode(.INSTRUCTION, activatedImageNamed: "instructions-color", disactivatedImageNamed: "instructions-black")
    let imagineButtonNode = ButtonSKNode(.IMAGINE, activatedImageNamed: "imagine-color", disactivatedImageNamed: "imagine-black")
    let gameCenterButtonNode = ButtonSKNode(.LEADERBOARD, activatedImageNamed: "gamecenter-color", disactivatedImageNamed: "gamecenter-black")
    //let levelButtonNode = ButtonSKNode(activatedImageNamed: "levels-color", disactivatedImageNamed: "levels-black")

    var robotHappyFrames = [SKTexture]()
    var robotSadFrames = [SKTexture]()
    var robotBlinkFrames = [SKTexture]()
    
    var expanded = false
    var recommendation = RECOMMEND.DONE
    
    override init() {
        
        super.init()
        
        imageNode.size = CGSize(width: 100, height: 100)
        addChild(imageNode)
        instructionButtonNode.zPosition = -3
        addChild(instructionButtonNode)
        imagineButtonNode.zPosition = -2
        addChild(imagineButtonNode)
        gameCenterButtonNode.zPosition = -1
        addChild(gameCenterButtonNode)
        robotHappyFrames = loadFrames("happy", imageNumber: 6, by: 1)
        robotSadFrames = loadFrames("sad", imageNumber: 7, by: 1)
        robotBlinkFrames = loadFrames("blink", imageNumber: 9, by: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleButton() {
        if expanded {
            switch recommendation {
            case .INSTRUCTION:
                instructionButtonNode.reduce()
                imagineButtonNode.collapse()
                gameCenterButtonNode.collapse()
            case .IMAGINE:
                instructionButtonNode.collapse()
                imagineButtonNode.reduce()
                gameCenterButtonNode.collapse()
            case .LEADERBOARD:
                instructionButtonNode.collapse()
                imagineButtonNode.collapse()
                gameCenterButtonNode.reduce()
            case .INSTRUCTION_OK, .DONE:
                instructionButtonNode.collapse()
                imagineButtonNode.collapse()
                gameCenterButtonNode.collapse()
            }
        } else {
            instructionButtonNode.expand()
            imagineButtonNode.expand()
            gameCenterButtonNode.expand()
        }
        expanded = !expanded
    }
    
    func recommend(recommendation: RECOMMEND) {
        self.recommendation = recommendation
        switch recommendation {
        case .INSTRUCTION:
            instructionButtonNode.pulse()
            if !expanded {
                instructionButtonNode.appear()
            }
        case .INSTRUCTION_OK:
            instructionButtonNode.unpulse()
            if !expanded {
                instructionButtonNode.disappear()
            }
        case .IMAGINE:
            if !imagineButtonNode.active {
                self.recommendation = RECOMMEND.DONE
                break
            }
            imagineButtonNode.pulse()
            if !expanded {
                imagineButtonNode.appear()
            }
        case .LEADERBOARD:
            //gameCenterButtonNode.pulse()
            if !gameCenterButtonNode.active {
                self.recommendation = RECOMMEND.DONE
                break
            }
            if !expanded {
                imagineButtonNode.disappear()
                gameCenterButtonNode.appear()
            }
        case .DONE:
            gameCenterButtonNode.unpulse()
            if !expanded {
                gameCenterButtonNode.disappear()
            }
        }
    }
    
    func animRobot(valence: Int) {
        let texture: [SKTexture]
        switch valence {
        case let x where x > 0 :
            texture = robotHappyFrames
        case let x where x < 0:
            texture = robotSadFrames
        default:
            texture = robotBlinkFrames
        }
        imageNode.runAction(SKAction.animateWithTextures(texture, timePerFrame: 0.05, resize: false, restore: false))
    }
    
    func loadFrames(imageName: String, imageNumber: Int, by: Int) -> [SKTexture] {
        var frames = [SKTexture]()
        for i in 1.stride(to: imageNumber, by: by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        for i in imageNumber.stride(to: 0, by: -by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        frames.append(SKTexture(imageNamed: imageName + "1"))
        return frames
    }
}