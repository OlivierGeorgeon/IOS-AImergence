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
            robotNode.jumpi()
            spawnExperienceNode(experience, position: robotNode.position , delay: 0.1)
            if leftFlippableNode != nil {
                explodeNode(leftFlippableNode!)
                leftFlippableNode = nil
            }
            if rightFlippableNode != nil {
                explodeNode(rightFlippableNode!)
                rightFlippableNode = nil
            }
        }
    }
    
    func explodeNode(node: SCNPhenomenonNode, delay: NSTimeInterval = 0) {
        let placeNode = SCNNode()
        placeNode.position = node.position
        worldNode.addChildNode(placeNode)
        node.runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.removeFromParentNode()]))
        
        func explode() {
            if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
                particles.particleColor = node.color()
                placeNode.addParticleSystem(particles)
            }
        }
        
        placeNode.runAction(SCNAction.waitForDuration(delay), completionHandler: explode)
        placeNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(delay + 0.2), SCNAction.removeFromParentNode()]))
    }
}


