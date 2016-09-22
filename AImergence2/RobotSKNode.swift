//
//  RobotSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 21/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

enum RECOMMEND: Int { case instruction, instruction_OK, imagine, leaderboard, done}

class RobotSKNode: SKNode
{
    let imageNode = SKSpriteNode(imageNamed: "robot")
    let instructionButtonNode = ButtonSKNode(.instruction, activatedImageNamed: "instructions-color", disactivatedImageNamed: "instructions-black")
    let imagineButtonNode = ButtonSKNode(.imagine, activatedImageNamed: "imagine-color", disactivatedImageNamed: "imagine-black")
    let gameCenterButtonNode = ButtonSKNode(.leaderboard, activatedImageNamed: "gamecenter-color", disactivatedImageNamed: "gamecenter-black")
    let saltoAction = SKAction.rotate(byAngle: CGFloat(-2 * M_PI), duration: 0.4)

    var jumpAction = SKAction()
    var winAction = SKAction()
    var robotHappyFrames = [SKTexture]()
    var robotSadFrames = [SKTexture]()
    var robotBlinkFrames = [SKTexture]()
    var robotCryFrames = [SKTexture]()
    var robotJumpFrames = [SKTexture]()
    var expanded = false
    var recommendation = RECOMMEND.done
    
    override init() {
        
        super.init()
        
        zPosition = 5
        addChild(imageNode)
        instructionButtonNode.zPosition = -3
        //instructionButtonNode.position = CGPoint(x: 0, y: 180)
        addChild(instructionButtonNode)
        imagineButtonNode.zPosition = -2
        addChild(imagineButtonNode)
        gameCenterButtonNode.zPosition = -1
        addChild(gameCenterButtonNode)
        robotHappyFrames = loadFrames("happy", imageNumber: 5, by: 1)
        robotSadFrames = loadFrames("sad", imageNumber: 6, by: 1)
        robotBlinkFrames = loadFrames("blink", imageNumber: 3, by: 1)
        robotCryFrames = loadFrames("cry", imageNumber: 6, by: 1)
        robotJumpFrames = loadFrames("jump", imageNumber: 6, by: 1)
        let upAction = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.25)
        let downAction = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.25)
        upAction.timingMode = .easeOut
        downAction.timingMode = .easeIn
        let jumpMoveAction = SKAction.sequence([upAction, downAction])
        let jumpAnimAction =  SKAction.animate(with: robotJumpFrames, timePerFrame: 0.05, resize: false, restore: false)
        jumpAction = SKAction.group([jumpMoveAction, jumpAnimAction])
        winAction = SKAction.sequence([jumpAction, SKAction.group([jumpAction, saltoAction])])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleButton() {
        if expanded {
            switch recommendation {
            case .instruction:
                instructionButtonNode.reduce()
                imagineButtonNode.collapse()
                gameCenterButtonNode.collapse()
            case .imagine:
                instructionButtonNode.collapse()
                imagineButtonNode.reduce()
                gameCenterButtonNode.collapse()
            case .leaderboard:
                instructionButtonNode.collapse()
                imagineButtonNode.collapse()
                gameCenterButtonNode.reduce()
            case .instruction_OK, .done:
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
    
    func recommend(_ recommendation: RECOMMEND) {
        self.recommendation = recommendation
        switch recommendation {
        case .instruction:
            instructionButtonNode.pulse()
            if !expanded {
                instructionButtonNode.appear()
            }
        case .instruction_OK:
            instructionButtonNode.unpulse()
            if !expanded {
                instructionButtonNode.disappear()
            }
        case .imagine:
            if !imagineButtonNode.active {
                self.recommendation = RECOMMEND.done
                break
            }
            imagineButtonNode.pulse()
            if !expanded {
                imagineButtonNode.appear()
            }
        case .leaderboard:
            imagineButtonNode.unpulse()
            //gameCenterButtonNode.pulse() done by GameViewController only if GameCenter is enabled
            if !gameCenterButtonNode.active {
                self.recommendation = RECOMMEND.done
                break
            }
            if !expanded {
                imagineButtonNode.disappear()
                gameCenterButtonNode.appear()
            }
        case .done:
            gameCenterButtonNode.unpulse()
            if !expanded {
                gameCenterButtonNode.disappear()
            }
        }
    }
    
    func animRobot(_ valence: Int) {
        switch valence {
        case 10:
            imageNode.run(winAction)
        case 3, 4:
            imageNode.run(jumpAction)
        case let x where x > 0 :
            imageNode.run(SKAction.animate(with: robotHappyFrames, timePerFrame: 0.05, resize: false, restore: false))
        case -10:
            imageNode.run(SKAction.animate(with: robotCryFrames, timePerFrame: 0.05, resize: false, restore: false))
        case let x where x < 0:
            imageNode.run(SKAction.animate(with: robotSadFrames, timePerFrame: 0.05, resize: false, restore: false))
        default:
            imageNode.run(SKAction.animate(with: robotBlinkFrames, timePerFrame: 0.05, resize: false, restore: false))
        }
    }
    
    func loadFrames(_ imageName: String, imageNumber: Int, by: Int) -> [SKTexture] {
        var frames = [SKTexture]()
        for i in stride(from: 0, to: imageNumber, by: by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        for i in stride(from: (imageNumber - 1), to: -1, by: -by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        frames.append(SKTexture(imageNamed: "robot"))
        return frames
    }
}
