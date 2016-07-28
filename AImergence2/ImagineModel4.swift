//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel4: ImagineModel3
{
    var bodyCell = 0
    
    var leftFlippableNode: SCNFlippableNode?
    var rightFlippableNode: SCNFlippableNode?
    
    override func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        worldNode.addChildNode(robotNode)
    }
    
    override func lightsAndCameras(scene: SCNScene)
    {
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
        cameraNode.position = SCNVector3(4 * scale, 1 * scale, 4 * scale)
        cameraNode.runAction(SCNAction.rotateByX(0, y: 0.75, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }
    
    override func playExperience(experience: Experience) {
        switch (experience.hashValue, bodyCell) {
        case (00, 0):
            robotNode.bumpBack()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()), delay: 0.1)
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlippableNode(robotNode.positionCell(robotNode.robot.cellBack())  + SCNVector3(-0.5 * scale, -0.2 * scale, 0), direction: Compass.EAST)
            }
        case (00, 1):
            spawnExperienceNode(experience, position: robotNode.position + tileYOffset, delay: 0.1)
            robotNode.moveBackward()
            rightFlippableNode?.flipToWest()
            bodyCell = 0
        case (01, 0):
            robotNode.bumpBack()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()), delay: 0.1)
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlippableNode(robotNode.positionCell(robotNode.robot.cellBack())  + SCNVector3(-0.5 * scale, -0.2 * scale, 0))
            }
            leftFlippableNode?.flip(0.2)
        case (10, 0):
            spawnExperienceNode(experience, position: robotNode.position + tileYOffset, delay: 0.1)
            robotNode.moveForward()
            leftFlippableNode?.flipToEast()
            bodyCell = 1
        case (10, 1):
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellFront()), delay: 0.1)
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlippableNode(robotNode.positionCell(robotNode.robot.cellFront())  + SCNVector3(0.5 * scale, -0.2 * scale, 0))
            }
        case (11, 1):
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellFront()), delay: 0.1)
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlippableNode(robotNode.positionCell(robotNode.robot.cellFront())  + SCNVector3(0.5 * scale, -0.2 * scale, 0), direction: Compass.WEST)
            }
            rightFlippableNode?.flip(0.2)
        default:
            break
        }
    }
    
    func createFlippableNode(position: SCNVector3 = SCNVector3(), direction:Compass = Compass.EAST) -> SCNFlippableNode {
        bodyNode = SCNFlippableNode()
        bodyNode.position = position
        worldNode.addChildNode(bodyNode)
        bodyNode.appear(direction: direction)
        return bodyNode
    }
}