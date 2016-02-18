//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class WorldScene0
{
    let actions = Actions()
    let scaleExperience = CGFloat(100)

    var worldNode = SCNNode()
    var bodyNode: SCNNode!
    var neutralNode: SCNNode!
    var enjoyableNode: SCNNode!
    
    func playExperience(experience: Experience) {
        switch experience.experiment.number {
        case 0:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bumpBack())
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0), delayed: true)
        case 1:
            createOrRetrieveBodyNodeAndRunAction(action: actions.bump())
            if enjoyableNode == nil { enjoyableNode = createEnjoyableNode(SCNVector3(1.25, 0, 0)) }
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0), delayed: true)
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
    
    func createPawnNode() -> SCNNode {
        let pawnNode = SCNNode()
        let cylinder = SCNNode(geometry: WorldPhenomena.halfCylinder())
        cylinder.position = SCNVector3(0, -0.25, 0)
        pawnNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: WorldPhenomena.sphere())
        pawnNode.addChildNode(sphere)
        pawnNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        return pawnNode
    }
    
    func createNeutralNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: WorldPhenomena.sphere())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }
    
    func createEnjoyableNode(position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: WorldPhenomena.brick())
        node.position = position
        worldNode.addChildNode(node)
        return node
    }
    
    func createExperienceNode(experience: Experience, position: SCNVector3, delayed:Bool = false) {
        let rect = CGRect(x: -0.2 * scaleExperience, y: -0.2 * scaleExperience, width: 0.4 * scaleExperience, height: 0.4 * scaleExperience)
        let path = ReshapableNode.paths[experience.experiment.shapeIndex](rect)
        let geometry = SCNShape(path: path, extrusionDepth: 0.1 * scaleExperience)
        geometry.materials = [WorldPhenomena.defaultMaterial()]
        if experience.colorIndex > 0 {
            geometry.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
        }
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(1/scaleExperience, 1/scaleExperience, 1/scaleExperience)
        experienceNode.position = position
        experienceNode.hidden = true
        worldNode.addChildNode(experienceNode)
        if delayed { experienceNode.runAction(actions.waitAndEmitExperience()) }
        else { experienceNode.runAction(actions.emitExperience()) }
    }
}