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
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bump())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 10:  // eat
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.waitAndToss())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            createOrRetrieveBodyNodeAndRunAction(action: actions.waitAndToss())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
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