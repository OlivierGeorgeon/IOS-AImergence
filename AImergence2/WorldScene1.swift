//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene1: WorldScene0
{
    let flip          = SCNAction.rotateByX(0.0, y: 0.0, z: CGFloat(M_PI), duration: 0.2)
    
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
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(rotateToRightBumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 01:
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 10:
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            bodyNode.runAction(rotateToLeftbumpRight)
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case 11:
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    func createSwitchNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: WorldPhenomena.cube())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }
}