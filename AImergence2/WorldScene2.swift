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
        
    let moveHalfUp = SCNAction.moveByX(0.0, y: 0.5, z: 0.0, duration: 0.1)
    let moveHalfdown = SCNAction.moveByX(0.0, y: -0.5, z: 0.0, duration: 0.1)
    
    var jump:SCNAction { return SCNAction.sequence([moveHalfUp, moveHalfdown]) }
    
    var up = false

    override func playExperience(experience: Experience)
    {
        if bodyNode == nil { createBodyNode() }
        switch experience.experiment.number
        {
        case 0:
            if switchNode0 == nil { createSwitchNode0() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(bumpLeft)
            } else {
                if up {
                    bodyNode.runAction(SCNAction.sequence([rotateToLeft, bumpLeftRotate]))
                    up = false
                } else {
                    bodyNode.runAction(bumpLeftRotate)
                }
            }
        case 1:
            if switchNode1 == nil { createSwitchNode1() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(bumpRight)
            } else {
                if up {
                    bodyNode.runAction(SCNAction.sequence([rotateToRight, bumpRightRotate]))
                    up = false
                } else {
                    bodyNode.runAction(bumpRightRotate)
                }
            }
        case 2:
            if up { bodyNode.runAction(jump) }
            else {
                bodyNode.runAction(SCNAction.sequence([rotateToUp, jump]))
                up = true
            }
        default:
            break
        }
    }
}