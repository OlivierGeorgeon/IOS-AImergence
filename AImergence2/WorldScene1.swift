//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene1: WorldScene0
{
    
    let rotateToUp = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI_2), duration: 0.2)
    let rotateToRight = SCNAction.rotateToX(0, y: 0, z: 0, duration: 0.2)
    let rotateToLeft = SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0.2)

    var bumpLeftRotate:SCNAction {return SCNAction.sequence([bumpLeft, rotateToRight])}
    var bumpRightRotate:SCNAction {return SCNAction.sequence([bumpRight, rotateToLeft])}
    
    var switchNode0: SCNNode!
    var switchNode1: SCNNode!

    override func playExperience(experience: Experience) {
        if bodyNode == nil {
            createBodyNode()
            if experience.experiment.number == 0 {
                bodyNode.runAction(SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0))
            }
        }
        switch experience.experiment.number {
        case 0:
            if switchNode0 == nil { createSwitchNode0() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(bumpLeft)
            } else {
                bodyNode.runAction(bumpLeftRotate)
            }
        case 1:
            if switchNode1 == nil { createSwitchNode1() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(bumpRight)
            } else {
                bodyNode.runAction(bumpRightRotate)
            }
        default:
            break
        }
    }
    
    func createSwitchNode0() {
        switchNode0 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode0.position = SCNVector3(-1.5, 0, 0)
        worldNode.addChildNode(switchNode0)
    }    

    func createSwitchNode1() {
        switchNode1 = SCNNode(geometry: WorldPhenomena.cube())
        switchNode1.position = SCNVector3(1.5, 0, 0)
        worldNode.addChildNode(switchNode1)
    }
}