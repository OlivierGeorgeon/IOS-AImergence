//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel009: ImagineModel005
{
    let carrouselNode = SCNNode()

    var actionRotateCarrousel: SCNAction { return SCNAction.rotateBy(x: 0.0, y: CGFloat(-M_PI) / 5, z: 0, duration: 0.5) }
    var carrouselDiameter: CGFloat { return 22}
    var nbSlotsInCarroussel: Int { return 10}
    
    var carrouselIndex = 0
    var slotNodes = [SCNNode]()

    override func setup(_ scene: SCNScene) {
        super.setup(scene)
        carrouselNode.position = SCNVector3( carrouselDiameter, -5, 0)
        worldNode.addChildNode(carrouselNode)
        actionRotateCarrousel.timingMode = .easeInEaseOut
        for i in 0..<nbSlotsInCarroussel {
            let slotNode = SCNNode()
            let angle = CGFloat(i) * 2 * CGFloat(M_PI) / CGFloat(nbSlotsInCarroussel) - CGFloat(M_PI)
            slotNode.position = SCNVector3(carrouselDiameter * cos(angle), 0, -carrouselDiameter * sin(angle))
            slotNode.rotation = SCNVector4(0, 1, 0, angle)
            carrouselNode.addChildNode(slotNode)
            slotNodes.append(slotNode)
        }
    }
    
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
            createOrRetrieveBodyNode(tileColor(experience), direction: .south, delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            currentTileNode = nil
            rotateCarrousel()
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), delay: 0.1)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0), delay: 0.1)
            currentTileNode = nil
            rotateCarrousel()
        case 20: // swap
            robotNode.jump()
            if currentTileNode == nil {
                if slotNodes[carrouselIndex].childNodes.count > 0 {
                    currentTileNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
                }
            }
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
            currentTileNode?.flip(delay: 0.2)
        default:
            break
        }
    }
    
    func createOrRetrieveBodyNode(_ color: UIColor?, position: SCNVector3 = SCNVector3(), direction: Compass = Compass.north, delay: TimeInterval = 0.0) //-> SCNFlipTileNode
    {
        if currentTileNode == nil {
            if slotNodes[carrouselIndex].childNodes.count > 0 {
                currentTileNode = slotNodes[carrouselIndex].childNodes[0] as? SCNFlipTileNode
            } else {
                currentTileNode = SCNFlipTileNode(color: color, direction: direction)
                slotNodes[carrouselIndex].addChildNode(currentTileNode!)
                currentTileNode?.appear(delay)
            }
        }
        if color != nil {
            currentTileNode?.colorize(color!, delay: delay)
        }
        //return currentTileNode!
    }

    func rotateCarrousel() {
        carrouselNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.1), actionRotateCarrousel]) )
        carrouselIndex += 1
        if carrouselIndex >= nbSlotsInCarroussel { carrouselIndex = 0 }
    }    
}
