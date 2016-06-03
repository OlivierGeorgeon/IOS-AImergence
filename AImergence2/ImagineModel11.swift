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
        
        //let robotScene = SCNScene(named: "art.scnassets/RobotjDer2.dae")!
        let robotScene = SCNScene(named: "art.scnassets/Robot9bJoints4a.dae")!
        
        let nodeArray = robotScene.rootNode.childNodes
        for childNode in nodeArray {
            robotNode.addChildNode(childNode as SCNNode)
        }
        
        robotNode.pivot = SCNMatrix4MakeRotation(Float(-M_PI/2), 0, 1, 0)
        robotNode.scale = SCNVector3(0.3, 0.3, 0.3)
        robotNode.addChildNode(createRobotCamera())
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
                    createTileNode(robotNode.positionForward() + SCNVector3(0, -0.5, 0))
                }
                spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delayed: true)
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

    func createRobotCamera() -> SCNNode {
        let bodyCamera = SCNNode()
        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(0.0, 15, -15)
        cameraNodes.append(bodyCamera)
        bodyCamera.runAction(SCNAction.rotateByX(-0.7, y: CGFloat(M_PI), z: 0, duration: 1))
        return bodyCamera
    }
    
    
}