//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel0: ImagineModel
{
    var neutralNode: SCNNode!
    var enjoyableNode: SCNNode!
    
    override func playExperience(experience: Experience) {
        switch experience.experiment.number {
        case 0:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delay: 0.1)
        case 1:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bump())
            if enjoyableNode == nil { enjoyableNode = createEnjoyableNode(SCNVector3(1.25, 0, 0)) }
            spawnExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0), delay: 0.1)
        default:
            break
        }
    }
    
    func createOrRetrieveBodyNodeAndRunAction(position: SCNVector3 = SCNVector3(), backward:Bool = false, action: SCNAction = SCNAction.unhide()) -> SCNNode {
        if bodyNode == nil {
            bodyNode = SCNNode()
            bodyNode.position = position
            bodyNode.hidden = backward
            bodyNode.addChildNode(createPawnNode())
            worldNode.addChildNode(bodyNode)
            if backward { bodyNode.runAction(SCNAction.sequence([actions.actionAppearBackward(), action])) }
            else { bodyNode.runAction(action) }
        } else {
            bodyNode.runAction(action)
        }
        return bodyNode
    }
    
    func createNeutralNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: Geometries.sphere())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }
    
    func createEnjoyableNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: Geometries.brick())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }
    
}