//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel2: ImagineModel1
{
    
    var leftFlippableNode: SCNFlipTileNode?
    var rightFlippableNode: SCNFlipTileNode?
    
    override func playExperience(_ experience: Experience) {
        switch experience.hashValue {
        case 00:
            robotNode.feelLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft())  + tileYOffset, direction: .south)
                leftFlippableNode?.appear(0.2)
            } else {
                leftFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 01:
            robotNode.feelLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellLeft())  + tileYOffset)
                leftFlippableNode?.appearAndFlip(false, delay: 0.2)
            } else {
                leftFlippableNode?.colorizeAndFlip(tileColor(experience), clockwise: false, delay: 0.2)
            }
            rightFlippableNode?.flip(delay: 0.2)
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.2)
        case 10:
            robotNode.feelRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight())  + tileYOffset, direction: .south)
                rightFlippableNode?.appear(0.2)
            } else {
                rightFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        case 11:
            robotNode.feelRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), position: robotNode.positionCell(robotNode.robot.cellRight())  + tileYOffset)
                rightFlippableNode?.appearAndFlip(delay: 0.2)
            } else {
                rightFlippableNode?.colorizeAndFlip(tileColor(experience), delay: 0.2)
            }
            leftFlippableNode?.flip(false, delay: 0.2)
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.2)
        default:
            break
        }
    }
    
    func createFlipTileNode(_ color: UIColor?, position: SCNVector3, direction:Compass = .north) -> SCNFlipTileNode {
        let node = SCNFlipTileNode(color: color, direction: direction)
        node.position = position
        worldNode.addChildNode(node)
        return node
    }    
}
