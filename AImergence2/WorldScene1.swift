//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene1: WorldScene0
{
    
    let rotateToUp    = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI_2), duration: 0.2)
    let rotateToRight = SCNAction.rotateToX(0, y: 0, z: 0, duration: 0.2)
    let rotateToLeft  = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0.2)

    var rotateToLeftBumpLeftRotateToRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToLeft]), SCNAction.group([moveHalfRight, rotateToRight])]) }
    var rotateToRightBumpLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToRight]), moveHalfRight]) }
    
    var rotateToRightbumpRightRotateToLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToRight]), SCNAction.group([moveHalfLeft, rotateToLeft])]) }
    var rotateToLeftbumpRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToLeft]), moveHalfLeft]) }

    var switchNode0: SCNNode!
    var switchNode1: SCNNode!

    override func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch experience.hashValue {
        case 00:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToRightBumpLeft)
        case 01:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
        case 10:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToLeftbumpRight)
        case 11:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
        default:
            break
        }
    }
    
    func createSwitchNode0() {
        switchNode0 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode0.position = SCNVector3(-1.5, 0, 0)
        worldNode.addChildNode(switchNode0)
    }    

    func createSwitchNode1() {
        switchNode1 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode1.position = SCNVector3(1.5, 0, 0)
        worldNode.addChildNode(switchNode1)
    }
}