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
    let moveUp = SCNAction.sequence([SCNAction.waitForDuration(0.5), SCNAction.moveByX(0.0, y: 1.5 * 10, z: 0.0, duration: 0.2)])
    let positionNextBodyNode = SCNVector3(0.0, -1.5 * 10, 0.0)
    
    var nextBodyNodeDirection: Compass!
    var canKnowNextBodyNode = false
    var nextBodyNode: SCNFlippableNode!

    override func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.position = SCNVector3(-1.5  * scale, 0, 0)
        worldNode.addChildNode(robotNode)
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
            createOrRetrieveBodyNodeAndRunAction()
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
        case 01:
            robotNode.feelFront()
            createOrRetrieveBodyNodeAndRunAction(direction: Compass.WEST)
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
        case 10:  // eat
            createOrRetrieveBodyNodeAndRunAction(action: actions.waitAndRemove())
            robotNode.bump()
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            createOrRetrieveBodyNodeAndRunAction(direction: Compass.WEST, action: actions.waitAndRemove())
            robotNode.bump()
            spawnExperienceNode(experience, position: SCNVector3( -0.5 * scale, 0.0, 0.0), delay: 0.1)
            bodyNode.childNodes[0].runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1),SCNAction.removeFromParentNode()]), completionHandler: explode)
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 20: // swap
            createOrRetrieveBodyNodeAndRunAction(direction: Compass.WEST, action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            createOrRetrieveBodyNodeAndRunAction(action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
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
    func createOrRetrieveBodyNodeAndRunAction(position: SCNVector3 = SCNVector3(), direction:Compass = Compass.EAST, action: SCNAction = SCNAction.unhide()) -> SCNFlippableNode {
        if bodyNode == nil {
            if nextBodyNode == nil {
                bodyNode = SCNFlippableNode()
                bodyNode.position = position
                //bodyNode.hidden = backward
                //bodyNode.addChildNode(createPawnNode())
                bodyNode.appear(direction: direction, action: action)
                worldNode.addChildNode(bodyNode)
                if direction == Compass.EAST {
                    nextBodyNodeDirection = Compass.WEST
                } else {
                    nextBodyNodeDirection = Compass.EAST
                }
            } else {
                bodyNode = nextBodyNode
                nextBodyNode = nil
                bodyNode.runAction(action)
            }
        } else {
            bodyNode.runAction(action)
        }
        createNextBodyNode()
        return bodyNode
    }
    
    func createNextBodyNode() {
        if nextBodyNode == nil && nextBodyNodeDirection != nil && canKnowNextBodyNode {
            nextBodyNode = SCNFlippableNode()
            nextBodyNode.position = positionNextBodyNode
            //nextBodyNode.hidden = nextBodyNodeBackward!
            //nextBodyNode.addChildNode(createPawnNode())
            worldNode.addChildNode(nextBodyNode)
            nextBodyNode.appear(direction: nextBodyNodeDirection)
            if nextBodyNodeDirection == Compass.EAST {
                nextBodyNodeDirection = Compass.WEST
            } else {
                nextBodyNodeDirection = Compass.EAST
            }
        }
    }    
}