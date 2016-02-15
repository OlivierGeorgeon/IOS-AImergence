//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene3: WorldScene1
{
    var moveLeft:SCNAction  { return SCNAction.group([SCNAction.moveByX(-1, y: 0.0, z: 0.0, duration: 0.1), rotateToLeft ])}
    var moveRight:SCNAction { return SCNAction.group([SCNAction.moveByX( 1, y: 0.0, z: 0.0, duration: 0.1), rotateToRight])}

    var bodyCell = 0
    
    override func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch (experience.hashValue, bodyCell) {
        case (00, 0):
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToRightBumpLeft)
            createTraceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case (00, 1):
            bodyNode.runAction(moveLeft)
            bodyCell = 0
            createTraceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case (01, 0):
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
            createTraceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case (10, 0):
            bodyNode.runAction(moveRight)
            bodyCell = 1
            createTraceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case (10, 1):
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToLeftbumpRight)
            createTraceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0))
        case (11, 1):
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
            createTraceNode(experience, position: SCNVector3( 2.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    override func createSwitchNode0() {
        switchNode0 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode0.position = SCNVector3(-1.5, 0, 0)
        worldNode.addChildNode(switchNode0)
    }    

    override func createSwitchNode1() {
        switchNode1 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode1.position = SCNVector3(2.5, 0, 0)
        worldNode.addChildNode(switchNode1)
    }
}