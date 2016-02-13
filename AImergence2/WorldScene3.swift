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
    let moveLeft = SCNAction.moveByX(-1, y: 0.0, z: 0.0, duration: 0.1)
    let moveRight = SCNAction.moveByX(1, y: 0.0, z: 0.0, duration: 0.1)

    var bodyX = 0
    var switchNode0X = 0
    var switchNode1X = 0
    
    override func playExperience(experience: Experience) {
        if bodyNode == nil     { createBodyNode() }
        switch experience.hashValue {
        case 00:
            switch switchNode0X {
            case 0:
                bodyNode.runAction(SCNAction.sequence([rotateToLeft, moveLeft]))
                bodyX -= 1
                switchNode0X = -2
                switchNode1X = 1
            case -1:
                if bodyX == 0 {
                    bodyNode.runAction(bumpLeft)
                } else {
                    bodyNode.runAction(moveLeft)
                    bodyX = 0
                }
            case -2:
                if bodyX == -1 {
                    bodyNode.runAction(bumpLeft)
                } else {
                    bodyNode.runAction(moveLeft)
                    bodyX = -1
                }
            default:
                break
            }
        case 01:
            if switchNode0X == 0 { switchNode0X = -1 }
            if switchNode1X == 0 { switchNode1X = 2 }
            if switchNode0 == nil  { createSwitchNode0() }
            bodyNode.runAction(bumpLeftRotate)
        case 10:
            switch switchNode1X {
            case 0:
                bodyNode.runAction(moveRight)
                bodyX += 1
                switchNode0X = -1
                switchNode1X = 2
            case 1:
                if bodyX == 0 {
                    bodyNode.runAction(bumpRight)
                } else {
                    bodyNode.runAction(moveRight)
                    bodyX = 0
                }
            case 2:
                if bodyX == 1 {
                    bodyNode.runAction(bumpRight)
                } else {
                    bodyNode.runAction(moveRight)
                    bodyX = 1
                }
            default:
                break
            }
        case 11:
            if switchNode1X == 0 { switchNode1X = 1 }
            if switchNode0X == 0 { switchNode0X = -2 }
            if switchNode1 == nil  { createSwitchNode1() }
            bodyNode.runAction(bumpRightRotate)
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