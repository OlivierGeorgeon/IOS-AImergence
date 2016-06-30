//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel8: ImagineModel5
{    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            createOrRetrieveBodyNodeAndRunAction(backward: true)
            //if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNodeAndRunAction()
            //if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.waitAndToss())
            //if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            //neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNodeAndRunAction(action: actions.waitAndToss())
            //if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5 * scale, 0, 0)) }
            //neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 20: // swap
            if nextBodyNode == nil { canKnowNextBodyNode = false }
            if bodyNode == nil { bodyNode = nextBodyNode; nextBodyNode = nil }
            if bodyNode != nil { bodyNode.runAction(actions.turnover()) }
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
}