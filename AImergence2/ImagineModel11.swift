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
    var constraint: SCNLookAtConstraint!
    
    override func setupSpecific(Scene: SCNScene) {
        //super.setup(scene)
        
        robotNode = SCNRobotNode()
        let robotBaseNode = SCNNode()
        robotNode.addChildNode(robotBaseNode)
        let caterpillarScene = SCNScene(named: "art.scnassets/ChenillesSeulesLarges.dae")!
        let baseNodeArray = caterpillarScene.rootNode.childNodes
        for childNode in baseNodeArray {
            robotBaseNode.addChildNode(childNode as SCNNode)
        }
        
        let robotBodyNode = SCNNode()
        robotBodyNode.name = "body"
        robotNode.addChildNode(robotBodyNode)
        let robotScene = SCNScene(named: "art.scnassets/Robot8aaNew2.dae")!
        let bodyNodeArray = robotScene.rootNode.childNodes
        for childNode in bodyNodeArray {
            robotBodyNode.addChildNode(childNode as SCNNode)
        }
        
        robotNode.pivot = SCNMatrix4MakeRotation(Float(-M_PI/2), 0, 1, 0)
        robotNode.scale = SCNVector3(0.3 * scale, 0.3 * scale, 0.3 * scale)
        robotNode.addChildNode(createRobotCamera())
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

    func createRobotCamera() -> SCNNode {
        let bodyCamera = SCNNode()
        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(0.0, 15, -15)
        cameraNodes.append(bodyCamera)
        bodyCamera.runAction(SCNAction.rotateByX(-0.7, y: CGFloat(M_PI), z: 0, duration: 1))
        return bodyCamera
    }
    
    
}