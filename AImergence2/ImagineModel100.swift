//
//  WorldScene1.swift
//  Little AI
//
//  Created by Olivier Georgeon on 11/02/16.
//  CC0 No rights reserved.
//
//  Controls the 3D model shown in the Replay window of Level200
//

import SceneKit

class ImagineModel100: ImagineModel000
{
    
    let localCenterNode = SCNNode()
    let remoteCenterNode = SCNNode()
    let remoteRobotNode = SCNRobotNode()
    let actionRotateFront = SCNAction.rotateBy(x: 0.0, y: CGFloat(Double.pi) / 2, z: 0.0, duration: 1)
    let actionRotateBack = SCNAction.rotateBy(x: 0.0, y: -CGFloat(Double.pi) / 2, z: 0.0, duration: 1)
    
    var localFront = false
    var remoteFront = false
    var local = 0
    var remote = 0
    
    override func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        
        actionRotateFront.timingMode = .easeInEaseOut
        actionRotateBack.timingMode = .easeInEaseOut
        
        worldNode.addChildNode(localCenterNode)
        robotNode = SCNRobotNode()
        robotNode.isHidden = true
        robotNode.position = SCNVector3Make(-7, 0, 0)
        localCenterNode.addChildNode(robotNode)
        robotNode.appearRight()
        
        worldNode.addChildNode(remoteCenterNode)
        remoteRobotNode.isHidden = true
        remoteRobotNode.position = SCNVector3Make(7, 0, 0)
        remoteRobotNode.appearLeft()
        remoteCenterNode.addChildNode(remoteRobotNode)
    }
    
    override func imagine(experiment: Experiment) {
        if experiment.number == 0 {
            localCenterNode.runAction(actionRotateFront)
            localFront = true
            local += 1
        } else {
            localCenterNode.runAction(actionRotateBack)
            localFront = false
            local -= 1
        }
    }
    
    override func imagine(remoteExperimentNumber: Int) {
        if remoteExperimentNumber == 0 {
            remoteFront = true
            remoteCenterNode.runAction(actionRotateFront)
            remote += 1
        } else {
            remoteFront = false
            remoteCenterNode.runAction(actionRotateBack)
            remote -= 1
        }
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
                localCenterNode.runAction(actionRotateFront)
                local += 1
            } else {
                localCenterNode.runAction(actionRotateBack)
                local -= 1
            }
            if remoteFront {
                remoteCenterNode.runAction(actionRotateFront)
                remote += 1
            } else {
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
