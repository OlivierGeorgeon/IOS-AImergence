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
    let moveLeft = SCNAction.moveByX(-20, y: 0, z: 0, duration: 0.35)
    let waitAndMoveLeft = SCNAction.sequence([SCNAction.waitForDuration(0.25), SCNAction.moveByX(-20, y: 0, z: 0, duration: 0.3)])
    let positionNextBodyNode = SCNVector3(40, -5, 0)
    
    var nextBodyNodeDirection: Compass?
    var canKnowNextBodyNode = false
    var currentTileNode: SCNFlipTileNode?
    var nextTileNode: SCNFlipTileNode!

    override func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.position = SCNVector3(-1.5  * scale, 0, 0)
        worldNode.addChildNode(robotNode)
        waitAndMoveLeft.timingMode = .EaseInEaseOut
        moveLeft.timingMode = .EaseOut
    }
    
    override func lightsAndCameras(scene: SCNScene) {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50 * scale, 50 * scale)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 1 * scale, 5 * scale)
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }

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
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(nil, position: tileYOffset)
                    currentTileNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextBodyNodeDirection = .SOUTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(nil, position: tileYOffset, delay: 0.2)
            //bodyNode?.flip(false, delay: 0.2)
            //bodyNode?.colorize(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
        case 21:
            robotNode.jump()
            if currentTileNode == nil {
                if nextTileNode == nil {
                    currentTileNode = createFlipTileNode(nil, position: tileYOffset, direction: .SOUTH)
                    currentTileNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextBodyNodeDirection = .NORTH
                } else {
                    currentTileNode = nextTileNode
                    currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
                    nextTileNode = nil
                }
            } else {
                currentTileNode?.flipAndColorize(tileColor(experience), clockwise: false, delay: 0.2)
            }
            createNextTileNode()
            //createOrRetrieveBodyNode(nil, position: tileYOffset, direction: .SOUTH, delay: 0.2)
            //bodyNode?.flip(false, delay: 0.2)
            //bodyNode?.colorize(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.3)
        default:
            break
        }
    }
    
    /*
    func createOrRetrieveBodyNode(color: UIColor?, position: SCNVector3 = SCNVector3(), direction:Compass = .NORTH, delay: NSTimeInterval = 0.0) -> SCNFlipTileNode {
        if bodyNode == nil {
            if nextBodyNode == nil {
                bodyNode = SCNFlipTileNode(color: color, direction: direction)
                bodyNode?.position = position
                bodyNode?.appear(delay)
                worldNode.addChildNode(bodyNode!)
                if direction == .NORTH {
                    nextBodyNodeDirection = .SOUTH
                } else {
                    nextBodyNodeDirection = .NORTH
                }
            } else {
                bodyNode = nextBodyNode
                nextBodyNode = nil
            }
        }
        if color != nil {
            bodyNode?.colorize(color!, delay: delay)
        }
        createNextBodyNode(delay)
        return bodyNode!
    }*/
    
    func createNextTileNode() {
        if nextTileNode == nil && nextBodyNodeDirection != nil && canKnowNextBodyNode {
            nextTileNode = SCNFlipTileNode(color: nil, direction: nextBodyNodeDirection!)
            nextTileNode.position = positionNextBodyNode
            worldNode.addChildNode(nextTileNode)
            //nextBodyNode.appear(delay)
            nextTileNode.appear()
            nextTileNode.runAction(moveLeft)
            if nextBodyNodeDirection == .NORTH {
                nextBodyNodeDirection = .SOUTH
            } else {
                nextBodyNodeDirection = .NORTH
            }
        }
    }    
}