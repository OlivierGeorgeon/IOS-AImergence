//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel5: ImagineModel4
{
    let moveLeft = SCNAction.moveBy(x: -20, y: 0, z: 0, duration: 0.35)
    let waitAndMoveLeft = SCNAction.sequence([SCNAction.wait(duration: 0.25), SCNAction.moveBy(x: -20, y: 0, z: 0, duration: 0.3)])
    let positionNextBodyNode = SCNVector3(40, -5, 0)
    
    var nextBodyNodeDirection: Compass?
    var canKnowNextBodyNode = false
    var currentTileNode: SCNFlipTileNode?
    var nextTileNode: SCNFlipTileNode!

    override func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.position = SCNVector3(-1.5  * scale, 0, 0)
        worldNode.addChildNode(robotNode)
        waitAndMoveLeft.timingMode = .easeInEaseOut
        moveLeft.timingMode = .easeOut
    }
    
    override func lightsAndCameras(_ scene: SCNScene) {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50 * scale, 50 * scale)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 1 * scale, 5 * scale)
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }

    override func imagine(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            robotNode.feelFront()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset, direction: .south)
                    currentTileNode?.appear(0.2)
                    nextBodyNodeDirection = .north
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
                    nextBodyNodeDirection = .south
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience), delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience), delay: 0.2)
            }
            createNextTileNode()
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(tileColor(experience), position: tileYOffset, direction: .south)
                    currentTileNode?.appear()
                    nextBodyNodeDirection = .north
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience))
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience))
            }
            createNextTileNode()
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
                    nextBodyNodeDirection = .south
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.colorize(tileColor(experience))
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.colorize(tileColor(experience))
            }
            createNextTileNode()
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(currentTileNode!, delay: 0.1)
            currentTileNode = nil
            canKnowNextBodyNode = true
            nextTileNode?.runAction(waitAndMoveLeft)
        case 20: // swap
            robotNode.jump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(nil, position: tileYOffset)
                    currentTileNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextBodyNodeDirection = .south
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
            }
            createNextTileNode()
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
        case 21:
            robotNode.jump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(nil, position: tileYOffset, direction: .south)
                    currentTileNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextBodyNodeDirection = .north
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
            }
            createNextTileNode()
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
        default:
            break
        }
    }
    
    func createNextTileNode() {
        if nextTileNode == nil && nextBodyNodeDirection != nil && canKnowNextBodyNode {
            nextTileNode = SCNFlipTileNode(color: nil, direction: nextBodyNodeDirection!)
            nextTileNode.position = positionNextBodyNode
            worldNode.addChildNode(nextTileNode)
            nextTileNode.appear()
            nextTileNode.runAction(moveLeft)
            if nextBodyNodeDirection == .north {
                nextBodyNodeDirection = .south
            } else {
                nextBodyNodeDirection = .north
            }
        }
    }    
}
