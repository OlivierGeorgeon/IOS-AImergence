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
    let scale = CGFloat(100)
    let moveHalfLeft  = SCNAction.moveByX(-0.5, y: 0.0, z: 0.0, duration: 0.1)
    let moveHalfRight = SCNAction.moveByX( 0.5, y: 0.0, z: 0.0, duration: 0.1)
    
    let moveUp = SCNAction.moveByX( 0.0, y: 5.0, z: 0.0, duration: 3.0)
    let remove = SCNAction.removeFromParentNode()
    let wait = SCNAction.waitForDuration(0.1)
    let unhide = SCNAction.unhide()
    
    var bumpLeft: SCNAction  {return SCNAction.sequence([moveHalfLeft, moveHalfRight])}
    var bumpRight: SCNAction {return SCNAction.sequence([moveHalfRight, moveHalfLeft])}
    var sparkle: SCNAction   {return SCNAction.sequence([wait, unhide, moveUp, remove])}

    var worldNode = SCNNode()
    var bodyNode: SCNNode!
    var neutralNode: SCNNode!
    var enjoyableNode: SCNNode!
    
    func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch experience.experiment.number {
        case 0:
            if neutralNode == nil { neutralNode = createNeutralNode(SCNVector3(-1.5, 0, 0)) }
            bodyNode.runAction(bumpLeft)
            createExperienceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 1:
            if enjoyableNode == nil { enjoyableNode = createEnjoyableNode(SCNVector3(1.25, 0, 0)) }
            bodyNode.runAction(bumpRight)
            createExperienceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
        default:
            break
        }
    }
    
    func createBodyNode() {
        bodyNode = SCNNode()
        let cylinder = SCNNode(geometry: WorldPhenomena.halfCylinder())
        cylinder.position = SCNVector3(0, -0.25, 0)
        bodyNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: WorldPhenomena.sphere())
        bodyNode.addChildNode(sphere)
        bodyNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        worldNode.addChildNode(bodyNode)
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
    
    func createExperienceNode(experience: Experience, position: SCNVector3) {
        let rect = CGRect(x: -0.2 * scale, y: -0.2 * scale, width: 0.4 * scale, height: 0.4 * scale)
        let path = ReshapableNode.paths[experience.experiment.shapeIndex](rect)
        let geometry = SCNShape(path: path, extrusionDepth: 0.1 * scale)
        geometry.materials = [WorldPhenomena.defaultMaterial()]
        if experience.colorIndex > 0 {
            geometry.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
        }
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(1/scale, 1/scale, 1/scale)
        experienceNode.position = position
        experienceNode.hidden = true
        worldNode.addChildNode(experienceNode)
        experienceNode.runAction(sparkle)
    }
    
}