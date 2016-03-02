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
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, backward: true, action: actions.bump())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 10:  // eat
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,backward: true)
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
            rotateCarrousel()
        case 11:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel)
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
            rotateCarrousel()
        case 20: // swap
            if bodyNode == nil {
                if carrouselNode.childNodes.count >= 10 {
                    bodyNode = carrouselNode.childNodes[carrouselIndex]
                }
            }
            if bodyNode != nil { bodyNode.runAction(actions.turnover()) }
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))

        default:
            break
        }
    }
}