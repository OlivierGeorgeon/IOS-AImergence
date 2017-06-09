//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  CC0 No rights reserved.
//

import SceneKit

class ImagineModel101: ImagineModel100
{
    let actionTurnover = SCNAction.rotateBy(x: 0.0, y: CGFloat(Double.pi), z: 0.0, duration: 0.5)
    let actionTurnoverClockwise = SCNAction.rotateBy(x: 0.0, y: -CGFloat(Double.pi), z: 0.0, duration: 0.5)
    var actionWaitAndTurnover = SCNAction()
    var actionWaitAndTurnoverClockwise = SCNAction()
    
    override func setup(_ scene: SCNScene) {
        super.setup(scene)
        actionRotateFront.timingMode = .easeIn
        actionRotateBack.timingMode = .easeIn
        actionTurnover.timingMode = .easeOut
        actionWaitAndTurnover = SCNAction.sequence([SCNAction.wait(duration: 1), actionTurnover])
        actionTurnoverClockwise.timingMode = .easeOut
        actionWaitAndTurnoverClockwise = SCNAction.sequence([SCNAction.wait(duration: 1), actionTurnoverClockwise])
    }
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
                if robotNode.robot.direction == .south {
                    robotNode.runAction(actionWaitAndTurnover)
                    robotNode.robot.direction = .north
                }
                localCenterNode.runAction(actionRotateFront)
                local += 1
            } else {
                if robotNode.robot.direction == .north {
                    robotNode.runAction(actionWaitAndTurnoverClockwise)
                    robotNode.robot.direction = .south
                }
                localCenterNode.runAction(actionRotateBack)
                local -= 1
            }
            if remoteFront {
                if remoteRobotNode.robot.direction == .north {
                    remoteRobotNode.runAction(actionWaitAndTurnover)
                    remoteRobotNode.robot.direction = .south
                }
                remoteCenterNode.runAction(actionRotateFront)
                remote += 1
            } else {
                if remoteRobotNode.robot.direction == .south {
                    remoteRobotNode.runAction(actionWaitAndTurnoverClockwise)
                    remoteRobotNode.robot.direction = .north
                }
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
