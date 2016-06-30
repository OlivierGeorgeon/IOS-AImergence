//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel11: ImagineModel
{
    override func setupSpecific(Scene: SCNScene) {
        //super.setup(scene)
        
        robotNode = SCNRobotNode()
        cameraNodes.append(robotNode.bodyCamera)
        worldNode.addChildNode(robotNode)

        constraint = SCNLookAtConstraint(target: robotNode)
        constraint.influenceFactor = 0.5
        //constraint.gimbalLockEnabled = true
        cameraNodes[0].constraints = [constraint]    
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
                if tiles[robotNode.robot.cellFront()] == nil {
                    createTileNode(robotNode.positionForward() + SCNVector3(0, -0.5 * scale, 0), delay: 0.1)
                }
                spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delay: 0.1)
            }
        default:
            robotNode.turnRight()
            spawnExperienceNode(experience, position: robotNode.position)
        }
    }
    
    func createTileNode(position: SCNVector3, delay: NSTimeInterval) -> SCNNode {
        let node = SCNNode(geometry: Geometries.tile())
        node.position = position
        node.hidden = true
        worldNode.addChildNode(node)
        let actionWait = SCNAction.waitForDuration(delay)
        node.runAction(SCNAction.sequence([actionWait, SCNAction.waitForDuration(0.1), SCNAction.unhide()]))
        return node
    }

    /*
    func createRobotCamera() -> SCNNode {
        let bodyCamera = SCNNode()
        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(0.0, 15, -15)
        cameraNodes.append(bodyCamera)
        bodyCamera.runAction(SCNAction.rotateByX(-0.7, y: CGFloat(M_PI), z: 0, duration: 1))
        return bodyCamera
    }
    */
    
}