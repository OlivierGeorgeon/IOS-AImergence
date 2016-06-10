//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel5: ImagineModel4
{
    let moveUp = SCNAction.sequence([SCNAction.waitForDuration(0.1), SCNAction.moveByX(0.0, y: 1.5, z: 0.0, duration: 0.2)])
    let positionNextBodyNode = SCNVector3(0.0, -1.5, 0.0)
    
    var nextBodyNodeBackward: Bool!
    var canKnowNextBodyNode = false
    var nextBodyNode: SCNNode!
    
    override func playExperience(experience: Experience) {
        switch experience.hashValue {
        case 00: // Touch
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.bump())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delay: 0.1)
        case 01:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delay: 0.1)
        case 10:  // eat
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.waitAndToss())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 11:
            createOrRetrieveBodyNodeAndRunAction(action: actions.waitAndToss())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            neutralNode.runAction(SCNAction.sequence([actions.moveHalfFront, actions.moveHalfBack]))
            spawnExperienceNode(experience, position: SCNVector3( -0.5, 0.0, 0.0), delay: 0.1)
            bodyNode = nil
            canKnowNextBodyNode = true
            nextBodyNode?.runAction(moveUp)
        case 20: // swap
            createOrRetrieveBodyNodeAndRunAction(action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        case 21:
            createOrRetrieveBodyNodeAndRunAction(backward: true, action: actions.turnover())
            spawnExperienceNode(experience, position: SCNVector3( 0.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    override func createOrRetrieveBodyNodeAndRunAction(position: SCNVector3 = SCNVector3(), backward:Bool = false, action: SCNAction = SCNAction.unhide()) -> SCNNode {
        if bodyNode == nil {
            if nextBodyNode == nil {
                bodyNode = SCNNode()
                bodyNode.position = position
                bodyNode.hidden = backward
                bodyNode.addChildNode(createPawnNode())
                worldNode.addChildNode(bodyNode)
                if backward { bodyNode.runAction(SCNAction.sequence([actions.actionAppearBackward(), action])) }
                else { bodyNode.runAction(action) }
                nextBodyNodeBackward = !backward
            } else {
                bodyNode = nextBodyNode
                nextBodyNode = nil
                bodyNode.runAction(action)
            }
        } else {
            bodyNode.runAction(action)
        }
        createNextBodyNode()
        return bodyNode
    }
    
    func createNextBodyNode() {
        if nextBodyNode == nil && nextBodyNodeBackward != nil && canKnowNextBodyNode {
            nextBodyNode = SCNNode()
            nextBodyNode.position = positionNextBodyNode
            nextBodyNode.hidden = nextBodyNodeBackward!
            nextBodyNode.addChildNode(createPawnNode())
            worldNode.addChildNode(nextBodyNode)
            if nextBodyNodeBackward! { nextBodyNode.runAction(actions.actionAppearBackward()) }
            nextBodyNodeBackward = !nextBodyNodeBackward
        }
    }
}