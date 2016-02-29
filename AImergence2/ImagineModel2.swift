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
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bumpAndTurnover())
            if switchNode0 == nil { switchNode0 = createSwitchNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 10:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bumpBack())
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0), delayed: true)
        case 11:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpAndTurnover())
            if switchNode1 == nil { switchNode1 = createSwitchNode(SCNVector3(1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0), delayed: true)
        default:
            break
        }
    }
}