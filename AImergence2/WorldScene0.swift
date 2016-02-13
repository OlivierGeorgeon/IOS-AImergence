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
    let moveLeft = SCNAction.moveByX(-0.5, y: 0.0, z: 0.0, duration: 0.1)
    let moveRight = SCNAction.moveByX(0.5, y: 0.0, z: 0.0, duration: 0.1)

    var worldNode = SCNNode()
    var bodyNode: SCNNode!
    private var neutralNode: SCNNode!
    private var enjoyableNode: SCNNode!
    
    func playExperience(experience: Experience) {
        if bodyNode == nil { createBodyNode() }
        switch experience.experiment.number {
        case 0:
            if neutralNode == nil { createNeutralNode() }
            //neutralNode.geometry!.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
            bodyNode.runAction(SCNAction.sequence([moveLeft, moveRight]))
        case 1:
            if enjoyableNode == nil { createEnjoyableNode() }
            //enjoyableNode.geometry!.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
            bodyNode.runAction(SCNAction.sequence([moveRight, moveLeft]))
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
    
    private func createNeutralNode() {
        neutralNode = SCNNode(geometry: WorldPhenomena.sphere())
        neutralNode.position = SCNVector3(-1.5, 0, 0)
        //neutralNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        worldNode.addChildNode(neutralNode)
    }
    
    private func createEnjoyableNode() {
        enjoyableNode = SCNNode(geometry: WorldPhenomena.cube())
        enjoyableNode.position = SCNVector3(1.5, 0, 0)
        worldNode.addChildNode(enjoyableNode)
    }
}