//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene2: WorldScene1
{
        
    let rotateToUp    = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI_2), duration: 0.2)
    let rotateToRight = SCNAction.rotateToX(0, y: 0, z: 0, duration: 0.2)
    let rotateToLeft  = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0.2)
    
    let moveHalfLeft  = SCNAction.moveByX(-0.5, y: 0.0, z: 0.0, duration: 0.1)
    let moveHalfRight = SCNAction.moveByX( 0.5, y: 0.0, z: 0.0, duration: 0.1)

    var rotateToLeftBumpLeftRotateToRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToLeft]), SCNAction.group([moveHalfRight, rotateToRight])]) }
    var rotateToRightBumpLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfLeft, rotateToRight]), moveHalfRight]) }
    var rotateToRightbumpRightRotateToLeft:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToRight]), SCNAction.group([moveHalfLeft, rotateToLeft])]) }
    var rotateToLeftbumpRight:SCNAction {return SCNAction.sequence([SCNAction.group([moveHalfRight, rotateToLeft]), moveHalfLeft]) }

    let moveHalfUp   = SCNAction.moveByX(0.0, y:  0.5, z: 0.0, duration: 0.1)
    let moveHalfDown = SCNAction.moveByX(0.0, y: -0.5, z: 0.0, duration: 0.1)
    
    var jump:SCNAction { return SCNAction.sequence([moveHalfUp, moveHalfDown]) }
    
    var leftAndBumpAndTurnover: SCNAction { return SCNAction.sequence([rotateToLeft, actions.bumpAndTurnover()]) }
    var RightAndBumpAndTurnover: SCNAction { return SCNAction.sequence([rotateToRight, actions.bumpAndTurnover()]) }
    
    override func playExperience(experience: Experience)
    {
        switch experience.hashValue {
        case 00:
            createOrRetrieveBodyNodeAndRunAction(action: rotateToRightBumpLeft)
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 01:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: rotateToLeftBumpLeftRotateToRight)
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 10:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: rotateToLeftbumpRight)
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case 11:
            createOrRetrieveBodyNodeAndRunAction(action: rotateToRightbumpRightRotateToLeft)
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case 20, 21:
            createOrRetrieveBodyNodeAndRunAction(action: SCNAction.group([rotateToUp, jump]))
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.5, 0.0))
        default:
            break
        }
    }
}