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
    //let waitAndToss = SCNAction.sequence([SCNAction.waitForDuration(0.1), SCNAction.moveByX( 5.0 * 10, y: 0.0, z: 0.0, duration: 0.3), SCNAction.removeFromParentNode()])
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: Compass.SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position:  SCNVector3( -5, -5, 0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, delay: 0.2)
            //if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position:  SCNVector3( -5, -5, 0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            //bodyNode!.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            //bodyNode!.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 20: // swap
            //createOrRetrieveBodyNode(nil, position: tileYOffset)
            if nextBodyNode == nil { canKnowNextBodyNode = false }
            if bodyNode == nil { bodyNode = nextBodyNode; nextBodyNode = nil }
            //if bodyNode != nil { bodyNode!.flipRight() }
            bodyNode?.flipRight()
            spawnExperienceNode(experience, position: tileYOffset)
        default:
            break
        }
    }
}