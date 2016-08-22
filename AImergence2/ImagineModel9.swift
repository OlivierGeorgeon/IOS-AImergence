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
    let actionRotateCarrousel = SCNAction.rotateByX(0.0, y: CGFloat(-M_PI) / 5, z: 0, duration: 0.5)
    let carrouselDiameter = CGFloat(22)
    let nbSlotsInCarroussel = 10
    let carrouselNode = SCNNode()
    
    var carrouselIndex = 0
    var slotNodes = [SCNNode]()

    override func setup(scene: SCNScene) {
        super.setup(scene)
        carrouselNode.position = SCNVector3( carrouselDiameter, -5, 0)
        worldNode.addChildNode(carrouselNode)
        actionRotateCarrousel.timingMode = .EaseInEaseOut
        for i in 0..<nbSlotsInCarroussel {
            let slotNode = SCNNode()
            let angle = CGFloat(i) * CGFloat(M_PI) / 5 - CGFloat(M_PI)
            slotNode.position = SCNVector3(carrouselDiameter * cos(angle), 0, -carrouselDiameter * sin(angle))
            slotNode.rotation = SCNVector4(0, 1, 0, angle)
            carrouselNode.addChildNode(slotNode)
            slotNodes.append(slotNode)
        }
    }
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), direction: .SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), direction: .SOUTH, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            bodyNode = nil
            rotateCarrousel()
        case 20: // swap
            robotNode.jump()
            if bodyNode == nil {
                if slotNodes[carrouselIndex].childNodes.count > 0 {
                    bodyNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
                }
            }
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.2)
            bodyNode?.flipRight(0.2)
        default:
            break
        }
    }
    
    override func createOrRetrieveBodyNode(color: UIColor?, position: SCNVector3 = SCNVector3(), direction: Compass = Compass.NORTH, delay: NSTimeInterval = 0.0) -> SCNFlipTileNode
    {
        if bodyNode == nil {
            if slotNodes[carrouselIndex].childNodes.count > 0 {
                bodyNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
            } else {
                bodyNode = SCNFlipTileNode(color: color, direction: direction)
                slotNodes[carrouselIndex].addChildNode(bodyNode!)
                bodyNode?.appear(delay)
            }
        }
        if color != nil {
            bodyNode?.colorize(color!, delay: delay)
        }
        return bodyNode!
    }

    func rotateCarrousel() {
        carrouselNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1), actionRotateCarrousel]) )
        carrouselIndex += 1
        if carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }    
}