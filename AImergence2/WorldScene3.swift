//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene3: WorldScene2
{
    var moveLeft:SCNAction  { return SCNAction.group([SCNAction.moveByX(-1, y: 0.0, z: 0.0, duration: 0.1), rotateToLeft ])}
    var moveRight:SCNAction { return SCNAction.group([SCNAction.moveByX( 1, y: 0.0, z: 0.0, duration: 0.1), rotateToRight])}

    var bodyCell = 0
    
    override func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch (experience.hashValue, bodyCell) {
        case (00, 0):
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(rotateToRightBumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case (00, 1):
            bodyNode.runAction(moveLeft)
            bodyCell = 0
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case (01, 0):
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case (10, 0):
            bodyNode.runAction(moveRight)
            bodyCell = 1
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case (10, 1):
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(2.5, 0, 0)) }
            bodyNode.runAction(rotateToLeftbumpRight)
            createExperienceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0))
        case (11, 1):
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(2.5, 0, 0)) }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
            createExperienceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0))
        default:
            break
        }
    }
}