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
        carrouselNode?.runAction(SCNAction.sequence([wait,actionRotateCarrousel]) )
        if ++carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }
    
    override func playExperience(experience: Experience) {
        if carrouselNode == nil { createCarrouselNode() }
        
        switch experience.hashValue {
        case 00: // Touch
            if bodyNode == nil { createOrRetreaveBodyNode() }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(bumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 01:
            if bodyNode == nil { createOrRetreaveBodyNodeLeft()}
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(bumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 10:  // eat
            if bodyNode == nil { createOrRetreaveBodyNode() }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(bumpRight)
            rotateCarrousel()
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0))
            bodyNode = nil
        case 11:
            if bodyNode == nil { createOrRetreaveBodyNodeLeft() }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(bumpRight)
            rotateCarrousel()
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0))
            bodyNode = nil
        case 20: // swap
            if bodyNode == nil { createOrRetreaveBodyNodeLeft()}
            bodyNode.runAction(flip)
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            if bodyNode == nil { createOrRetreaveBodyNode() }
            bodyNode.runAction(flip)
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    func createOrRetreaveBodyNode() {
        if carrouselNode?.childNodes.count >= 10 {
            bodyNode = carrouselNode?.childNodes[carrouselIndex]
        } else {
            createBodyNode()
            bodyNode.hidden = true
            bodyNode.position = positionInCarroussel
            bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle - CGFloat(M_PI), duration: 0.0), unhide]))
            carrouselNode?.addChildNode(bodyNode)
        }
    }

    func createOrRetreaveBodyNodeLeft() {
        if carrouselNode?.childNodes.count >= 10 {
            bodyNode = carrouselNode?.childNodes[carrouselIndex]
        } else {
            createBodyNode()
            bodyNode.hidden = true
            bodyNode.position = positionInCarroussel
            bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle, duration: 0.0), unhide]))
            carrouselNode?.addChildNode(bodyNode)
        }
    }

    func createCarrouselNode() {
        carrouselNode = SCNNode()
        carrouselNode!.position = SCNVector3( carrouselDiameter, 0.0, 0.0)
        worldNode.addChildNode(carrouselNode!)
    }
}