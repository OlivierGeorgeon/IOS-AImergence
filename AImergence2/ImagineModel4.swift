//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel4: ImagineModel3
{
    var moveLeft:SCNAction  { return SCNAction.group([SCNAction.moveByX(-1, y: 0.0, z: 0.0, duration: 0.2), rotateToLeft ])}
    var moveRight:SCNAction { return SCNAction.group([SCNAction.moveByX( 1, y: 0.0, z: 0.0, duration: 0.2), rotateToRight])}

    var bodyCell = 0
    
    override func playExperience(experience: Experience) {
        switch (experience.hashValue, bodyCell) {
        case (00, 0):
            createOrRetrieveBodyNodeAndRunAction(action: rotateToRightBumpLeft)
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case (00, 1):
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: moveLeft)
            bodyCell = 0
            spawnExperienceNode(experience, position: SCNVector3( 0.5, 0.0, 0.0), delayed: true)
        case (01, 0):
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: rotateToLeftBumpLeftRotateToRight)
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case (10, 0):
            createOrRetrieveBodyNodeAndRunAction(action: moveRight)
            bodyCell = 1
            spawnExperienceNode(experience, position: SCNVector3( 0.5, 0.0, 0.0), delayed: true)
        case (10, 1):
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: rotateToLeftbumpRight)
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(2.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0), delayed: true)
        case (11, 1):
            createOrRetrieveBodyNodeAndRunAction(action: rotateToRightbumpRightRotateToLeft)
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(2.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0), delayed: true)
        default:
            break
        }
    }
}