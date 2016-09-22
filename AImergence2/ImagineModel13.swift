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
    
    override func playExperience(_ experience: Experience) {
        constraint.influenceFactor = 0.5
        switch experience.experiment.number {
        case 0:
            robotNode.turnLeft()
            spawnExperienceNode(experience, position: robotNode.position)
        case 1:
            switch experience.resultNumber {
            case 1:
                robotNode.moveForward()
                spawnExperienceNode(experience, position: robotNode.position)
            default:
                constraint.influenceFactor = 0
                robotNode.bump()
                if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellFront()) == nil {
                    createTileNode(tileColor(experience), position: robotNode.positionForward() + SCNVector3(0, -0.5 * scale, 0), delay: 0.1)
                }
                spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delay: 0.1)
            }
        case 2:
            robotNode.turnRight()
            spawnExperienceNode(experience, position: robotNode.position)
        default:
            robotNode.feelFront()
            spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector() / 2, delay: 0.2)
            if experience.resultNumber == 1 {
                if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellFront()) == nil {
                    createTileNode(tileColor(experience), position: robotNode.positionForward() + SCNVector3(0, -0.5 * scale, 0), delay: 0.2)
                }
            }
        }
    }
}
