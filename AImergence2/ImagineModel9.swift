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
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel, direction: .SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel, direction: .SOUTH)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 20: // swap
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel, direction: .SOUTH)
            bodyNode?.flipRight()
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            createOrRetrieveBodyNode(tileColor(experience), position: positionInCarroussel)
            bodyNode?.flipRight()
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    override func createOrRetrieveBodyNode(color: UIColor?, position: SCNVector3 = SCNVector3(), direction: Compass = Compass.NORTH, delay: NSTimeInterval = 0.0) -> SCNFlipTileNode
    {
        if bodyNode == nil {
            if carrouselNode.childNodes.count >= 10 {
                bodyNode = carrouselNode.childNodes[carrouselIndex] as? SCNFlipTileNode
                //bodyNode?.runAction(action)
            } else {
                bodyNode = SCNFlipTileNode(color: color, direction: direction)
                bodyNode?.position = position
                carrouselNode.addChildNode(bodyNode!)
                if direction == Compass.WEST {
                    bodyNode?.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle, duration: delay), SCNAction.unhide()])) }
                else { bodyNode?.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: 0.0, z: carrouselAngle - CGFloat(M_PI), duration: delay), SCNAction.unhide()])) }
            }
        }
        return bodyNode!
    }

    func rotateCarrousel() {
        carrouselAngle = CGFloat(M_PI) / 5.0 + carrouselAngle
        carrouselNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),actionRotateCarrousel]) )
        carrouselIndex += 1
        if carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }    
}