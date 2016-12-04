//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel21: ImagineModel0
{
    
    let remoteRobotNode = SCNRobotNode()

    override func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        robotNode.position = SCNVector3Make(-10, 0, 0)
        worldNode.addChildNode(robotNode)
        
        remoteRobotNode.isHidden = true
        remoteRobotNode.position = SCNVector3Make(10, 0, 0)
        remoteRobotNode.appearBack()
        worldNode.addChildNode(remoteRobotNode)
    }
    
    override func imagine(experiment: Experiment) {
        if experiment.number == 0 {
            robotNode.feelFrontRight()
        } else {
            robotNode.feelFrontLeft()
        }
    }
    
    override func imagine(remoteExperimentNumber: Int) {
        if remoteExperimentNumber == 0 {
            remoteRobotNode.feelFrontRight()
        } else {
            remoteRobotNode.feelFrontLeft()
        }
    }
    
    override func imagine(experience: Experience) {
        spawnExperienceNode(experience, position: SCNVector3Make(0, 0, 0), delay: 0.1)
    }
}
