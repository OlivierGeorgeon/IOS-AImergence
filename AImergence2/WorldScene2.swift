//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene2: WorldScene1
{
        
    let moveHalfUp   = SCNAction.moveByX(0.0, y:  0.5, z: 0.0, duration: 0.1)
    let moveHalfDown = SCNAction.moveByX(0.0, y: -0.5, z: 0.0, duration: 0.1)
    
    var jump:SCNAction { return SCNAction.sequence([moveHalfUp, moveHalfDown]) }
    
    override func playExperience(experience: Experience)
    {
        if bodyNode == nil { createBodyNode() }
        switch experience.hashValue {
        case 00:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToRightBumpLeft)
            createTraceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 01:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
            createTraceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 10:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToLeftbumpRight)
            createTraceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case 11:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
            createTraceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        case 20, 21:
            bodyNode.runAction(SCNAction.group([rotateToUp, jump]))
            createTraceNode(experience, position: SCNVector3( 0.0, 0.5, 0.0))
        default:
            break
        }
    }
}