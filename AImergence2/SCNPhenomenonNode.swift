//
//  SCNPhenomenon.swift
//  Little AI
//
//  Created by Olivier Georgeon on 19/08/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class SCNPhenomenonNode: SCNNode {
    
    let headNode = SCNNode()

    var headColor = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
    
    override init() {
        super.init()
        self.hidden = true
    }
    
    convenience init(color: UIColor) {
        self.init()

        let tileGeometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.specular.contents = UIColor.whiteColor()
        tileGeometry.materials = [material]

        headNode.geometry = tileGeometry
        addChildNode(headNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func appear(delay: NSTimeInterval = 0) {
        runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.unhide()]))
    }
    
    func colorizeHeadBloc(node: SCNNode) {
        if let phenomenonNode  = node as? SCNPhenomenonNode {
            phenomenonNode.headNode.geometry!.firstMaterial!.diffuse.contents = phenomenonNode.headColor
        }
    }

    func colorize(color: UIColor, delay: NSTimeInterval = 0.0) {
        headColor = color
        let actionWait = SCNAction.waitForDuration(delay)
        let actionColorize = SCNAction.runBlock(colorizeHeadBloc)
        runAction(SCNAction.sequence([actionWait, actionColorize]))
    }
    
    func color() -> UIColor {
        if let color = headNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
            return color
        } else {
            return UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        }
    }
    
    func explode(node: SCNNode) {
        if let phenomenonNode = node as? SCNPhenomenonNode {
            phenomenonNode.hideChildren()
            if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
                particles.particleColor = phenomenonNode.color()
                phenomenonNode.addParticleSystem(particles)
            }
        }
    }
    
    func hideChildren() {
        headNode.hidden = true
    }
}