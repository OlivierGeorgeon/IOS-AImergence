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
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00:
            robotNode.feelLeft()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellLeft()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
        case 01:
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
            robotNode.feelLeftAndTurnOver()
        case 10:
            robotNode.feelRight()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellRight()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
        case 11:
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
            robotNode.feelRightAndTurnOver()
        default:
            break
        }
    }
 
/*
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0 * scale, 0.0, 0.0), delay: 0.1)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bumpAndTurnover())
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0 * scale, 0.0, 0.0), delay: 0.1)
        case 10:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bumpBack())
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 1.0 * scale, 0.0, 0.0), delay: 0.1)
        case 11:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpAndTurnover())
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5 * scale, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 1.0 * scale, 0.0, 0.0), delay: 0.1)
        default:
            break
        }
    }
 */
}