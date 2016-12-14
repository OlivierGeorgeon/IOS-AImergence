//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel001: ImagineModel000
{
    var switchNode0: SCNNode!
    var switchNode1: SCNNode!

    override func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.isHidden = true
        robotNode.appearRight()
        worldNode.addChildNode(robotNode)
    }
    
    override func lightsAndCameras(_ scene: SCNScene) {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        //omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        //omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.light!.color = UIColor(white: 0.4, alpha: 1.0)
        //omniLightNode.position = SCNVector3Make(0, 50 * scale, 50 * scale)
        omniLightNode.position = SCNVector3Make(50, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let omniLightNode2 = SCNNode()
        omniLightNode2.light = SCNLight()
        omniLightNode2.light!.type = SCNLight.LightType.omni
        //omniLightNode2.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode2.light!.color = UIColor(white: 0.4, alpha: 1.0)
        omniLightNode2.position = SCNVector3Make(50, 50, -50)
        scene.rootNode.addChildNode(omniLightNode2)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0 * scale, 1 * scale, 5 * scale)
        //cameraNode.runAction(SCNAction.rotateByX(0, y: CGFloat(M_PI) / 2, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }
    
    override func imagine(experience: Experience) {
        switch experience.hashValue {
        case 00: // Left
            robotNode.feelLeft()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellLeft()) == nil  {
                createTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, chamferRadius: 0, delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 01:
            robotNode.feelLeft()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellLeft()) == nil  {
                createTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 10: // Right
            robotNode.feelRight()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellRight()) == nil  {
                createTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, chamferRadius: 0, delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 11:
            robotNode.feelRight()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellRight()) == nil  {
                createTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 20, 21: // swap
            robotNode.turnOver()
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
}
