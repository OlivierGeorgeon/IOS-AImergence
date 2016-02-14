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
    let moveHalfdown = SCNAction.moveByX(0.0, y: -0.5, z: 0.0, duration: 0.1)
    
    var jump:SCNAction { return SCNAction.sequence([moveHalfUp, moveHalfdown]) }
    
    override func playExperience(experience: Experience)
    {
        if bodyNode == nil { createBodyNode() }
        switch experience.hashValue {
        case 00:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToRightBumpLeft)
        case 01:
            if switchNode0 == nil { createSwitchNode0() }
            bodyNode.runAction(rotateToLeftBumpLeftRotateToRight)
        case 10:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToLeftbumpRight)
        case 11:
            if switchNode1 == nil { createSwitchNode1() }
            bodyNode.runAction(rotateToRightbumpRightRotateToLeft)
        case 20, 21:
            bodyNode.runAction(SCNAction.group([rotateToUp, jump]))
        default:
            break
        }
    }
}