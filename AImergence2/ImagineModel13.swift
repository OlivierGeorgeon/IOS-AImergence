//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel13: ImagineModel12
{
    
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
        case 2:
            robotNode.turnRight()
            spawnExperienceNode(experience, position: robotNode.position, delayed: false)
        default:
            robotNode.feelFront()
            spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delayed: true)
            if experience.resultNumber == 1 {
                if tiles[robotNode.robot.cellFront()] == nil {
                    createTileNode(robotNode.positionForward() + SCNVector3(0, -0.5, 0))
                }
            }
        }
    }
    
   
}