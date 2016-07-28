//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel3: ImagineModel1
{
    
    var tileNode: SCNNode?
        
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00:
            robotNode.feelLeft()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellLeft()) == nil  {
                tileNode = createTileNode(robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
        case 01:
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellLeft()) + tileYOffset, delay: 0.1)
            robotNode.feelLeftAndTurnOver()
        case 10:
            robotNode.feelRight()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellRight()) == nil  {
                tileNode = createTileNode(robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
        case 11:
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellRight()) + tileYOffset, delay: 0.1)
            robotNode.feelRightAndTurnOver()
        default:
            robotNode.jumpi()
            if tileNode == nil {
                spawnExperienceNode(experience, position: robotNode.position)
            } else {
                spawnExperienceNode(experience, position: tileNode!.position)
                robotNode.knownCells.removeAll()
                let placeNode = SCNNode()
                placeNode.position = tileNode!.position
                worldNode.addChildNode(placeNode)
                tileNode?.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.2), SCNAction.removeFromParentNode()]))
                tileNode = nil
                
                func explode() {
                    if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
                        placeNode.addParticleSystem(particles)
                    }
                }
                
                placeNode.runAction(SCNAction.waitForDuration(0.2), completionHandler: explode)
                placeNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.4), SCNAction.removeFromParentNode()]))
            }
        }
    }


    
 /*
    let rotateToUp    = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI_2), duration: 0.2)
    let rotateToRight = SCNAction.rotateToX(0, y: 0, z: 0, duration: 0.2)
    let rotateToLeft  = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0.2)
    
    let moveHalfLeft  = SCNAction.moveByX(-0.5 * 10, y: 0.0, z: 0.0, duration: 0.1)
    let moveHalfRight = SCNAction.moveByX( 0.5 * 10, y: 0.0, z: 0.0, duration: 0.1)

    var rotateToLeftBumpLeftRotateToRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToLeft]), SCNAction.group([moveHalfRight, rotateToRight])]) }
    var rotateToRightBumpLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToRight]), moveHalfRight]) }
    var rotateToRightbumpRightRotateToLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToRight]), SCNAction.group([moveHalfLeft, rotateToLeft])]) }
    var rotateToLeftbumpRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToLeft]), moveHalfLeft]) }

    let moveHalfUp   = SCNAction.moveByX(0.0, y:  0.5 * 10, z: 0.0, duration: 0.1)
    let moveHalfDown = SCNAction.moveByX(0.0, y: -0.5 * 10, z: 0.0, duration: 0.1)
    
    var jump:SCNAction { return SCNAction.sequence([moveHalfUp, moveHalfDown]) }
*/    
    //var leftAndBumpAndTurnover: SCNAction { return SCNAction.sequence([rotateToLeft, actions.bumpAndTurnover()]) }
    //var RightAndBumpAndTurnover: SCNAction { return SCNAction.sequence([rotateToRight, actions.bumpAndTurnover()]) }
    
}