//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel9: ImagineModel5
{
    let actionRotateCarrousel = SCNAction.rotateByX(0.0, y: 0.0, z: CGFloat(-M_PI) / 5.0, duration: 0.5)
    
    let carrouselDiameter = CGFloat(2.2 * 10)
    let nbSlotsInCarroussel = 10
    
    var carrouselNode = SCNNode()
    
    var carrouselAngle = CGFloat(M_PI)
    
    var positionInCarroussel:SCNVector3 { return SCNVector3(carrouselDiameter * cos(carrouselAngle), carrouselDiameter * sin(carrouselAngle), 0)}

    var carrouselIndex = 0
    
    override func setup(scene: SCNScene) {
        super.setup(scene)
        carrouselNode.position = SCNVector3( carrouselDiameter, 0.0, 0.0)
        worldNode.addChildNode(carrouselNode)
    }
    
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
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, direction: Compass.WEST, action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            createOrRetrieveBodyNodeAndRunAction(positionInCarroussel, action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    override func createOrRetrieveBodyNodeAndRunAction(position: SCNVector3 = SCNVector3(), direction: Compass = Compass.EAST, action: SCNAction = SCNAction.unhide(), delay: NSTimeInterval = 0.0) -> SCNFlippableNode
    {
        if bodyNode == nil {
            if carrouselNode.childNodes.count >= 10 {
                bodyNode = carrouselNode.childNodes[carrouselIndex] as! SCNFlippableNode
                bodyNode.runAction(action)
            } else {
                bodyNode = SCNFlippableNode()
                bodyNode.position = position
                carrouselNode.addChildNode(bodyNode)
                if direction == Compass.WEST {
                    bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle, duration: delay), actions.unhide, action])) }
                else { bodyNode.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle - CGFloat(M_PI), duration: delay), actions.unhide, action])) }
            }
        } else {
            bodyNode.runAction(action)
        }
        return bodyNode
    }

    func rotateCarrousel() {
        carrouselAngle = CGFloat(M_PI) / 5.0 + carrouselAngle
        carrouselNode.runAction(SCNAction.sequence([actions.wait,actionRotateCarrousel]) )
        carrouselIndex += 1
        if carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }    
}