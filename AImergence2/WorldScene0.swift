//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
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
    private var neutralNode: SCNNode!
    private var enjoyableNode: SCNNode!
    
    func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch experience.experiment.number {
        case 0:
            if neutralNode == nil { createNeutralNode() }
            bodyNode.runAction(bumpLeft)
            createTraceNode(experience, position: SCNVector3( -1.0, 0.0, 0.0))
        case 1:
            if enjoyableNode == nil { createEnjoyableNode() }
            bodyNode.runAction(bumpRight)
            createTraceNode(experience, position: SCNVector3( 1.0, 0.0, 0.0))
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
    
    func createNeutralNode() {
        neutralNode = SCNNode(geometry: WorldPhenomena.sphere())
        neutralNode.position = SCNVector3(-1.5, 0, 0)
        worldNode.addChildNode(neutralNode)
    }
    
    func createEnjoyableNode() {
        enjoyableNode = SCNNode(geometry: WorldPhenomena.cube())
        enjoyableNode.position = SCNVector3(1.5, 0, 0)
        worldNode.addChildNode(enjoyableNode)
    }
    
    func createTraceNode(experience: Experience, position: SCNVector3) {
        let rect = CGRect(x: -0.2 * scale, y: -0.2 * scale, width: 0.4 * scale, height: 0.4 * scale)
        let path = ReshapableNode.paths[experience.experiment.shapeIndex](rect)
        let geometry = SCNShape(path: path, extrusionDepth: 0.1 * scale)
        if experience.colorIndex == 0 {
            geometry.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        } else {
            geometry.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
        }
        geometry.firstMaterial!.specular.contents = UIColor.whiteColor()
        let traceNode = SCNNode(geometry: geometry)
        traceNode.scale = SCNVector3(1/scale, 1/scale, 1/scale)
        traceNode.position = position
        traceNode.hidden = true
        worldNode.addChildNode(traceNode)
        traceNode.runAction(sparkle)
    }
    
}