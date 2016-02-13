//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene3: WorldScene1
{
    let moveLeft1 = SCNAction.moveByX(-1, y: 0.0, z: 0.0, duration: 0.1)
    let moveRight1 = SCNAction.moveByX(1, y: 0.0, z: 0.0, duration: 0.1)

    var bodyX = 0
    var switchNode0X = 0
    var switchNode1X = 0
    
    override func playExperience(experience: Experience) {
        if bodyNode == nil     { createBodyNode() }
        switch experience.hashValue {
        case 00:
            switch switchNode0X {
            case 0:
                bodyNode.runAction(SCNAction.sequence([moveLeft1, rotate]))
                bodyX -= 1
                switchNode0X = -2
                switchNode1X = 1
            case -1:
                if bodyX == 0 {
                    bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight]))
                } else {
                    bodyNode.runAction(moveLeft1)
                    bodyX = 0
                }
            case -2:
                if bodyX == -1 {
                    bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight]))
                } else {
                    bodyNode.runAction(moveLeft1)
                    bodyX = -1
                }
            default:
                break
            }
        case 01:
            if switchNode0X == 0 { switchNode0X = -1 }
            if switchNode1X == 0 { switchNode1X = 2 }
            if switchNode0 == nil  { createSwitchNode0() }
            bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight, rotate]))
        case 10:
            switch switchNode1X {
            case 0:
                bodyNode.runAction(moveRight1)
                bodyX += 1
                switchNode0X = -1
                switchNode1X = 2
            case 1:
                if bodyX == 0 {
                    bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft]))
                } else {
                    bodyNode.runAction(moveRight1)
                    bodyX = 0
                }
            case 2:
                if bodyX == 1 {
                    bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft]))
                } else {
                    bodyNode.runAction(moveRight1)
                    bodyX = 1
                }
            default:
                break
            }
        case 11:
            if switchNode1X == 0 { switchNode1X = 1 }
            if switchNode0X == 0 { switchNode0X = -2 }
            if switchNode1 == nil  { createSwitchNode1() }
            bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft, rotate]))
        default:
            break
        }
    }
    
    override func createSwitchNode0() {
        switchNode0 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode0.position = SCNVector3(CGFloat(switchNode0X) - 0.5, 0, 0)
        worldNode.addChildNode(switchNode0)
    }    

    override func createSwitchNode1() {
        switchNode1 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode1.position = SCNVector3(CGFloat(switchNode1X) + 0.5, 0, 0)
        worldNode.addChildNode(switchNode1)
    }
}