//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  CC0 No rights reserved.
//

import SceneKit

class ImagineModel004: ImagineModel003
{
    var bodyCell = 0
    
    override func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        worldNode.addChildNode(robotNode)
    }
    
    override func lightsAndCameras(_ scene: SCNScene)
    {
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
        cameraNode.position = SCNVector3(4 * scale, 1 * scale, 4 * scale)
        cameraNode.runAction(SCNAction.rotateBy(x: 0, y: 0.75, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }
    
    override func imagine(experience: Experience) {
        if experience.hashValue == 11 {
            bodyCell = 1
        }
        switch (experience.hashValue, bodyCell) {
        case (00, 0):
            robotNode.bumpBack()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()) + tileYOffset, delay: 0.1)
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellBack())  + SCNVector3(-5, -5, 0), direction: .south)
                leftFlippableNode?.appear(0.1)
            } else {
                leftFlippableNode?.colorize(tileColor(experience), delay: 0.1)
            }
        case (00, 1):
            spawnExperienceNode(experience, position: robotNode.position)
            robotNode.moveBackward()
            if rightFlippableNode?.direction == .south {
                rightFlippableNode?.flip()
            }
            bodyCell = 0
        case (01, 0):
            robotNode.bumpBack()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()) + tileYOffset, delay: 0.1)
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellBack())  + SCNVector3(-5, -5, 0))
                leftFlippableNode?.appearAndFlip(delay: 0.1)
            } else {
                leftFlippableNode?.colorizeAndFlip(tileColor(experience), delay: 0.1)
            }
        case (10, 0):
            spawnExperienceNode(experience, position: robotNode.position)
            robotNode.moveForward()
            if leftFlippableNode?.direction == .south {
                leftFlippableNode?.flip(false)
            }
            bodyCell = 1
        case (10, 1):
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellFront()) + tileYOffset, delay: 0.1)
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellFront())  + SCNVector3(5, -5, 0), direction: .south)
                rightFlippableNode?.appear(0.1)
            } else {
                rightFlippableNode?.colorize(tileColor(experience), delay: 0.1)
            }
        case (11, 1):
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellFront()) + tileYOffset, delay: 0.1)
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellFront()) + SCNVector3(5, -5, 0))
                rightFlippableNode?.appearAndFlip(false, delay: 0.1)
            } else {
                rightFlippableNode?.colorizeAndFlip(tileColor(experience), clockwise: false, delay: 0.1)
            }
        default:
            break
        }
    }
}
