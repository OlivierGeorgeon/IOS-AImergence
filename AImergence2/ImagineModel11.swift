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
    
    var robotNode: SCNRobotNode!
    var tiles = [Cell: SCNNode]()
    
    override func setup(scene: SCNScene) {
        super.setup(scene)
        
        robotNode = SCNRobotNode()
        let cylinder = SCNNode(geometry: Geometries.halfCylinder())
        cylinder.position = SCNVector3(0, -0.25, 0)
        robotNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: Geometries.sphere())
        robotNode.addChildNode(sphere)
        robotNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        robotNode = robotNode.flattenedClone()
        worldNode.addChildNode(robotNode)
    }
    
    override func playExperience(experience: Experience) {
        switch experience.experiment.number {
        case 0:
            robotNode.turnLeft()
            spawnExperienceNode(experience, position: robotNode.position, delayed: false)
        case 1:
            switch experience.resultNumber {
            case 1:
                robotNode.moveForward()
                spawnExperienceNode(experience, position: robotNode.position, delayed: false)
            default:
                robotNode.bump()
                if tiles[robotNode.robot.cellFront()] == nil {
                    createTileNode(robotNode.positionForward() + SCNVector3(0, -0.4, 0))
                }
                spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector(), delayed: true)
            }
        default:
            robotNode.turnRight()
            spawnExperienceNode(experience, position: robotNode.position, delayed: false)
        }
    }
    
    func createTileNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: Geometries.tile())
        node.position = position
        node.hidden = true
        worldNode.addChildNode(node)
        node.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.1), SCNAction.unhide()]))
        return node
    }
    
}