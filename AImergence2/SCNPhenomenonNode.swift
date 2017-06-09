//
//  SCNPhenomenon.swift
//  Little AI
//
//  Created by Olivier Georgeon on 19/08/16.
//  CC0 No rights reserved.
//

import Foundation
import SceneKit

class SCNPhenomenonNode: SCNNode {
    
    let headNode = SCNNode()

    var headColor = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
    
    override init() {
        super.init()
        self.isHidden = true
    }
    
    convenience init(color: UIColor, chamferRadius:CGFloat) {
        self.init()

        let tileGeometry = SCNBox(width: 10, height: 2, length: 10, chamferRadius: chamferRadius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.specular.contents = UIColor.white
        if #available(iOS 10.0, *) {
            material.metalness.contents = 1
        }
        tileGeometry.materials = [material]

        headNode.geometry = tileGeometry
        addChildNode(headNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func appear(_ delay: TimeInterval = 0) {
        runAction(SCNAction.sequence([SCNAction.wait(duration: delay), SCNAction.unhide()]))
    }
    
    func colorizeHeadBloc(_ node: SCNNode) {
        if let phenomenonNode  = node as? SCNPhenomenonNode {
            phenomenonNode.headNode.geometry!.firstMaterial!.diffuse.contents = phenomenonNode.headColor
        }
    }

    func colorize(_ color: UIColor, delay: TimeInterval = 0.0) {
        headColor = color
        let actionWait = SCNAction.wait(duration: delay)
        let actionColorize = SCNAction.run(colorizeHeadBloc)
        runAction(SCNAction.sequence([actionWait, actionColorize]))
    }
    
    func color() -> UIColor {
        if let color = headNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
            return color
        } else {
            return UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        }
    }
    
    func explode(_ node: SCNNode) {
        if let phenomenonNode = node as? SCNPhenomenonNode {
            phenomenonNode.hideChildren()
            if let particles = SCNParticleSystem(named: "Confetti.scnp", inDirectory: nil) {
                particles.particleColor = phenomenonNode.color()
                phenomenonNode.addParticleSystem(particles)
            }
        }
    }
    
    func hideChildren() {
        headNode.isHidden = true
    }
}
