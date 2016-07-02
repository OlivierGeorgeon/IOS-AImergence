//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel0: ImagineModel
{    
    override func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        worldNode.addChildNode(robotNode)
    }
    
    override func playExperience(experience: Experience) {
        switch experience.experiment.number {
        case 1:
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector(), delay: 0.1)
        default:
            robotNode.bumpBack()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellBack()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellBack()) + SCNVector3(-0.5 * scale, -0.5 * scale, 0), delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()) + tileYOffset, delay: 0.1)
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
    

}