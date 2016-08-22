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
    var nextBodyNode: SCNFlipTileNode!

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
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.2)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, delay: 0.2)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.2)
        case 10:  // eat
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset, direction: .SOUTH)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(waitAndMoveLeft)
        case 11:
            robotNode.bump()
            createOrRetrieveBodyNode(tileColor(experience), position: tileYOffset)
            spawnExperienceNode(experience, position: SCNVector3( -5, -5, 0.0), delay: 0.1)
            explodeNode(bodyNode!, delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(waitAndMoveLeft)
        case 20: // swap
            robotNode.jump()
            createOrRetrieveBodyNode(nil, position: tileYOffset, delay: 0.2)
            bodyNode?.flipLeft(0.2)
            bodyNode?.colorize(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.2)
        case 21:
            robotNode.jump()
            createOrRetrieveBodyNode(nil, position: tileYOffset, direction: .SOUTH, delay: 0.2)
            bodyNode?.flipLeft(0.2)
            bodyNode?.colorize(tileColor(experience), delay: 0.2)
            spawnExperienceNode(experience, position: tileYOffset, delay: 0.2)
        default:
            break
        }
    }
    
    func explode() {
        if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
            bodyNode?.addParticleSystem(particles)
            bodyNode = nil
            
        }
    }
    
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
    }
    
    func createNextBodyNode(delay: NSTimeInterval) {
        if nextBodyNode == nil && nextBodyNodeDirection != nil && canKnowNextBodyNode {
            nextBodyNode = SCNFlipTileNode(color: nil, direction: nextBodyNodeDirection!)
            nextBodyNode.position = positionNextBodyNode
            worldNode.addChildNode(nextBodyNode)
            //nextBodyNode.appear(delay)
            nextBodyNode.appear()
            nextBodyNode.runAction(moveLeft)
            if nextBodyNodeDirection == .NORTH {
                nextBodyNodeDirection = .SOUTH
            } else {
                nextBodyNodeDirection = .NORTH
            }
        }
    }    
}