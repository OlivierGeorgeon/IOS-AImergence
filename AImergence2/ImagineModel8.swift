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
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: Compass.SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position:  SCNVector3( -5, -5, 0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, delay: 0.2)
            spawnExperienceNode(experience, position:  SCNVector3( -5, -5, 0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 20: // swap
            if nextBodyNode == nil { canKnowNextBodyNode = false }
            if bodyNode == nil { bodyNode = nextBodyNode; nextBodyNode = nil }
            bodyNode?.flipRight()
            spawnExperienceNode(experience, position: tileYOffset)
        default:
            break
        }
    }
}