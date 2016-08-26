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
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
                    currentTileNode?.appear(0.2)
                    nextBodyNodeDirection = .NORTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience), delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience), delay: 0.2)
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset)
                    currentTileNode?.appear(0.2)
                    nextBodyNodeDirection = .SOUTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience), delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience), delay: 0.2)
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
                    currentTileNode?.appear()
                    nextBodyNodeDirection = .NORTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience))
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience))
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(currentTileNode!, delay: 0.1)
            currentTileNode = nil
            canKnowNextBodyNode = true
            nextTileNode?.runAction(waitAndMoveLeft)
        case 11:
            robotNode.bump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset)
                    currentTileNode?.appear()
                    nextBodyNodeDirection = .SOUTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience))
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience))
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(currentTileNode!, delay: 0.1)
            currentTileNode = nil
            canKnowNextBodyNode = true
            nextTileNode?.runAction(waitAndMoveLeft)
        case 20: // swap
            robotNode.jump()
            if nextTileNode == nil { canKnowNextBodyNode = false }
            if currentTileNode == nil { currentTileNode = nextTileNode; nextTileNode = nil }
            currentTileNode?.flip(false, delay: 0.2)
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
        default:
            break
        }
    }
}