//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel10: ImagineModel9
{
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, direction: Compass.WEST, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, direction: Compass.WEST, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 20: // swap
            if bodyNode == nil {
                if carrouselNode.childNodes.count >= 10 {
                    bodyNode = carrouselNode.childNodes[carrouselIndex] as! SCNFlippableNode
                }
            }
            if bodyNode != nil { bodyNode.runAction(turnover) }
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))

        default:
            break
        }
    }
}