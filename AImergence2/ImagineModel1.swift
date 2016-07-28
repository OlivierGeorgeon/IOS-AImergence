//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel1: ImagineModel0
{
    var switchNode0: SCNNode!
    var switchNode1: SCNNode!

    override func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.hidden = true
        robotNode.appearRight()
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
        cameraNode.position = SCNVector3(0 * scale, 1 * scale, 5 * scale)
        //cameraNode.runAction(SCNAction.rotateByX(0, y: CGFloat(M_PI) / 2, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
    }
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Left
            robotNode.feelLeft()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellLeft()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 01:
            robotNode.feelLeft()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 10: // Right
            robotNode.feelRight()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellRight()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 11:
            robotNode.feelRight()
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 20, 21: // swap
            robotNode.turnOver()
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }

    /*
    func createSwitchNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: Geometries.cube())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }*/
}