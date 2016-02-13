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
    
    let rotate = SCNAction.rotateByX(0, y: 0, z: CGFloat(M_PI), duration: 0.2)
    
    var switchNode0: SCNNode!
    var switchNode1: SCNNode!

    override func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch experience.experiment.number {
        case 0:
            if switchNode0 == nil { createSwitchNode0() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight]))
            } else {
                bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight, rotate]))
            }
        case 1:
            if switchNode1 == nil { createSwitchNode1() }
            if experience.resultNumber == 0 {
                bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft]))
            } else {
                bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft, rotate]))
            }
        default:
            break
        }
    }
    
    /*
    override func createBodyNode() {
        bodyNode = SCNNode(geometry: WorldPhenomena.pyramid())
        bodyNode.position = SCNVector3(-0.5, 0, 0)
        bodyNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        worldNode.addChildNode(bodyNode)
    }
*/

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