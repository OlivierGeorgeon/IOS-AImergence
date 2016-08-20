//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel11: ImagineModel0
{
    override func setup(scene: SCNScene) {
        robotNode = SCNRobotNode()
        lightsAndCameras(scene)
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
        
        constraint = SCNLookAtConstraint(target: robotNode)
        constraint.influenceFactor = 0.5
        //constraint.gimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        scene.rootNode.addChildNode(worldNode)
    }

    override func playExperience(experience: Experience) {
        constraint.influenceFactor = 0.5
        switch experience.experiment.number {
        case 0:
            robotNode.turnLeft()
            spawnExperienceNode(experience, position: robotNode.position, delay: 0.1)
        case 1:
            switch experience.resultNumber {
            case 1:
                robotNode.moveForward()
                spawnExperienceNode(experience, position: robotNode.position, delay: 0.1)
            default:
                constraint.influenceFactor = 0
                robotNode.bump()
                if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellFront()) == nil {
                    createTileNode(tileColor(experience), position: robotNode.positionForward() + tileYOffset, delay: 0.1)
                }
                spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delay: 0.1)
            }
        default:
            robotNode.turnRight()
            spawnExperienceNode(experience, position: robotNode.position)
        }
    }
}