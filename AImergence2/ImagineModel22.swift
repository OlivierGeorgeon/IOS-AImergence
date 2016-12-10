//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel22: ImagineModel21
{
    override func imagine(experience: Experience) {
        if experience.resultNumber == 0 {
            if localFront {
                localCenterNode.runAction(actionRotateBack)
                local -= 1
            } else {
                localCenterNode.runAction(actionRotateFront)
                local += 1
            }
            if remoteFront {
                remoteCenterNode.runAction(actionRotateBack)
                remote -= 1
            } else {
                remoteCenterNode.runAction(actionRotateFront)
                remote += 1
            }
        } else {
            if localFront {
                robotNode.turnOver()
                localCenterNode.runAction(actionRotateFront)
                local += 1
            } else {
                robotNode.turnOver2()
                localCenterNode.runAction(actionRotateBack)
                local -= 1
            }
            if remoteFront {
                remoteRobotNode.turnOver2()
                remoteCenterNode.runAction(actionRotateFront)
                remote += 1
            } else {
                remoteRobotNode.turnOver()
                remoteCenterNode.runAction(actionRotateBack)
                remote -= 1
            }
        }
        spawnExperienceNode(experience, position: SCNVector3Make(0, 0, 0), delay: 0.1)
        // needed if the imagine window is open after sending data
        while remote < local {
            remoteCenterNode.runAction(actionRotateFront)
            remote += 1
        }
        while local < remote {
            localCenterNode.runAction(actionRotateFront)
            local += 1
        }
    }

}
