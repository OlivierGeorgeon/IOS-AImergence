//
//  AnimatedSKNode.swift
//  AImergence
//
//  Created by Olivier Georgeon on 18/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

struct Actions
{
    let moveUpExperience = SCNAction.moveByX( 0.0, y: 5.0, z: 0.0, duration: 3.0)
    
    let moveForward:SCNAction = SCNAction.moveByX( 1, y: 0.0, z: 0.0, duration: 0.2)
    let moveBackward:SCNAction = SCNAction.moveByX( -1, y: 0.0, z: 0.0, duration: 0.2)
    
    let moveHalfFront = SCNAction.moveByX( 0.5, y: 0.0, z: 0.0, duration: 0.1)
    let moveHalfBack  = SCNAction.moveByX(-0.5, y: 0.0, z: 0.0, duration: 0.1)

    let remove = SCNAction.removeFromParentNode()
    let wait = SCNAction.waitForDuration(0.1)
    let unhide = SCNAction.unhide()
    
    let moveFarRight = SCNAction.moveByX( 2.0, y: 0.0, z: 0.0, duration: 1.0)
    let shrink = SCNAction.scaleBy(0.0, duration: 1.0)

    func emitExperience() -> SCNAction {
        return SCNAction.sequence([unhide, moveUpExperience, remove])
    }
    
    func waitAndEmitExperience() -> SCNAction {
        return SCNAction.sequence([wait,  emitExperience()])
    }
    
    func actionAppearBackward() -> SCNAction {
        return SCNAction.sequence([turnover(duration: 0), unhide])
    }
    
    func bump() -> SCNAction {
        return SCNAction.runBlock(bumpBlock)
    }
    
    func bumpAndTurnover() -> SCNAction {
        return SCNAction.group([SCNAction.runBlock(bumpBlock), SCNAction.sequence([wait, turnover()])])
    }
    
    func bumpBack() -> SCNAction {
        return SCNAction.runBlock(bumpBackBlock)
    }
    
    func turnover(angle: CGFloat = CGFloat(M_PI), duration: Double = 0.2) -> SCNAction {
        return SCNAction.rotateByX(0.0, y: 0.0, z: angle , duration: duration)
    }
    
    func toss() -> SCNAction {
        let actionRoll = SCNAction.repeatAction(turnover(CGFloat(-M_PI)), count: 5)
        return SCNAction.sequence([SCNAction.group([shrink, actionRoll, moveFarRight]), remove])
    }
    
    func waitAndToss() -> SCNAction {
        return SCNAction.sequence([wait, toss()])
    }

    func bumpBlock(node: SCNNode) {
        if node.childNodes.count > 0 {
            node.childNodes[0].runAction(SCNAction.sequence([moveHalfFront, moveHalfBack]))
        }
    }
    
    func bumpBackBlock(node: SCNNode) {
        if node.childNodes.count > 0 {
            node.childNodes[0].runAction(SCNAction.sequence([moveHalfBack, moveHalfFront]))
        }
    }
}

