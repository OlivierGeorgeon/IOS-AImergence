//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene7: WorldScene4
{
    let actionRotateCarrousel = SCNAction.rotateByX(0.0, y: 0.0, z: CGFloat(-M_PI) / 5.0, duration: 1.0)
    
    let carrouselDiameter = CGFloat(2.2)
    let nbSlotsInCarroussel = 10
    
    var carrouselNode: SCNNode?
    
    var carrouselAngle = CGFloat(M_PI)
    
    var positionInCarroussel:SCNVector3 { return SCNVector3(carrouselDiameter * cos(carrouselAngle), carrouselDiameter * sin(carrouselAngle), 0)}

    var carrouselIndex = 0
    
    func rotateCarrousel() {
        carrouselAngle = CGFloat(M_PI) / 5.0 + carrouselAngle
        carrouselNode?.runAction(SCNAction.sequence([actions.wait,actionRotateCarrousel]) )
        if ++carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }
    
    override func playExperience(experience: Experience) {
        if carrouselNode == nil { createCarrouselNode() }
        
        switch experience.hashValue {
        case 00: // Touch
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, backward: true, action: actions.bump())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 10:  // eat
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel)
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
            rotateCarrousel()
        case 11:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,backward: true)
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delayed: true)
            bodyNode = nil
            rotateCarrousel()
        case 20: // swap
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,backward: true, action: actions.turnover())
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel ,action: actions.turnover())
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    override func createOrRetrieveBodyNodeAndRunAction(position: SCNVector3 = SCNVector3(), backward:Bool = false, action: SCNAction = SCNAction.unhide()) -> SCNNode
    {
        if bodyNode == nil {
            if carrouselNode?.childNodes.count >= 10 {
                bodyNode = carrouselNode?.childNodes[carrouselIndex]
                bodyNode.runAction(action)
            } else {
                bodyNode = SCNNode()
                bodyNode.position = position
                bodyNode.hidden = true
                bodyNode.addChildNode(createPawnNode())
                carrouselNode!.addChildNode(bodyNode)
                if backward { bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle, duration: 0.0), actions.unhide, action])) }
                else { bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle - CGFloat(M_PI), duration: 0.0), actions.unhide, action])) }
            }
        } else {
            bodyNode.runAction(action)
        }
        return bodyNode
    }
    
    func createCarrouselNode() {
        carrouselNode = SCNNode()
        carrouselNode!.position = SCNVector3( carrouselDiameter, 0.0, 0.0)
        worldNode.addChildNode(carrouselNode!)
    }
}