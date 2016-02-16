//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene4: WorldScene3
{
    let actionMoveFarRight = SCNAction.moveByX( 10.0, y: 0.0, z: 0.0, duration: 2.0)
    
    var actionUnhideLeft: SCNAction { return SCNAction.sequence([SCNAction.rotateToX(0, y: 0, z: CGFloat(M_PI), duration: 0, shortestUnitArc:true), unhide]) }
    var actionTossRight: SCNAction { return SCNAction.sequence([wait, actionMoveFarRight, remove]) }
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            if bodyNode == nil { createBodyNode() }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(bumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 01:
            if bodyNode == nil { createBodyNode(); bodyNode.hidden = true }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(SCNAction.sequence([actionUnhideLeft, bumpLeft]))
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 10:  // eat
            if bodyNode == nil { createBodyNode() }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(bumpRight)
            bodyNode.runAction(actionTossRight)
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0))
            bodyNode = nil
        case 11:
            if bodyNode == nil { createBodyNode(); bodyNode.hidden = true }
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(bumpRight)
            bodyNode.runAction(SCNAction.sequence([actionUnhideLeft, actionTossRight]))
            createExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0))
            bodyNode = nil
        case 20: // swap
            if bodyNode == nil { createBodyNode(); bodyNode.hidden = true }
            bodyNode.runAction(SCNAction.sequence([actionUnhideLeft, rotateToRight]))
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            if bodyNode == nil { createBodyNode() }
            bodyNode.runAction(rotateToLeft)
            createExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
}