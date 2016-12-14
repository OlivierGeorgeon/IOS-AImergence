//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel202: ImagineModel009
{
    override var actionRotateCarrousel: SCNAction { return SCNAction.rotateBy(x: 0.0, y: CGFloat(-M_PI), z: 0, duration: 0.5) }
    override var carrouselDiameter: CGFloat { return 5 }
    override var nbSlotsInCarroussel: Int { return 2 }
    
    override func imagine(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), direction: .south, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(nil, direction: .south, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            currentTileNode = nil
            rotateCarrousel()
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(nil, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            currentTileNode = nil
            rotateCarrousel()
        case 20: // swap
            robotNode.jump()
            if currentTileNode == nil {
                if slotNodes[carrouselIndex].childNodes.count > 0 {
                    currentTileNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
                } else {
                    createOrRetrieveBodyNode(nil, direction: .north, delay: 0.2)
                }
            }
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.2)
            currentTileNode?.flipAndColorize(tileColor(experience), delay: 0.2)
        case 21: // swap
            robotNode.jump()
            if currentTileNode == nil {
                if slotNodes[carrouselIndex].childNodes.count > 0 {
                    currentTileNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
                } else {
                    createOrRetrieveBodyNode(nil, direction: .south, delay: 0.2)
                }
            }
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.2)
            currentTileNode?.flipAndColorize(tileColor(experience), delay: 0.2)
        default:
            break
        }
    }
}
