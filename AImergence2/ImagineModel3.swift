//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel3: ImagineModel2
{
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00:
            robotNode.feelLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft())  + tileYOffset, direction: .SOUTH, delay: 0.2)
            } else {
                leftFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 01:
            robotNode.feelLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft())  + tileYOffset, delay: 0.2)
            } else {
                leftFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            leftFlippableNode?.flipLeft(0.2)
            rightFlippableNode?.flipRight(0.2)
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 10:
            robotNode.feelRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight())  + tileYOffset, direction: .SOUTH, delay: 0.2)
            } else {
                rightFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 11:
            robotNode.feelRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight())  + tileYOffset, delay: 0.2)
            } else {
                rightFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            leftFlippableNode?.flipLeft(0.2)
            rightFlippableNode?.flipRight(0.2)
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        default:
            robotNode.jump()
            spawnExperienceNode(experience, position: robotNode.position , delay: 0.1)
            if leftFlippableNode != nil {
                explodeNode(leftFlippableNode!, delay: 0.2)
                leftFlippableNode = nil
            }
            if rightFlippableNode != nil {
                explodeNode(rightFlippableNode!, delay: 0.2)
                rightFlippableNode = nil
            }
        }
    }
    
    func explodeNode(node: SCNPhenomenonNode, delay: NSTimeInterval = 0) {
        let placeNode = SCNNode()
        placeNode.position = node.position
        placeNode.setValue(node.color(), forKey: "color")
        worldNode.addChildNode(placeNode)
        node.runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.removeFromParentNode()]))
        placeNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.runBlock(explode), SCNAction.waitForDuration(2), SCNAction.removeFromParentNode()]))
    }
    
    func explode(placeNode: SCNNode) {
        if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
            particles.particleColor = placeNode.valueForKey("color") as! UIColor
            placeNode.addParticleSystem(particles)
        }
    }
}


