//
//  SCNFlippableNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 01/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class SCNFlippableNode: SCNNode {

    let actionFlip = SCNAction.rotateByX(0.0, y: 0.0, z: CGFloat(M_PI) , duration: 0.2)
    let actionInstantFlip = SCNAction.rotateByX(0.0, y: 0.0, z: CGFloat(M_PI) , duration: 0)
    var direction = Compass.EAST
    
    override init()
    {
        super.init()
        
        let pawnNode = SCNNode()
        let cylinder = SCNNode(geometry: Geometries.halfCylinder())
        cylinder.position = SCNVector3(0, -2.5 , 0)
        pawnNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: Geometries.sphere())
        pawnNode.addChildNode(sphere)
        pawnNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        addChildNode(pawnNode.flattenedClone())
        hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip(delay: NSTimeInterval = 0.0) {
        runAction(SCNAction.sequence([SCNAction.waitForDuration(delay),actionFlip]))
        if direction == Compass.EAST {
            direction = Compass.WEST
        } else {
            direction = Compass.EAST
        }
    }
    
    func flipToEast() {
        if direction == Compass.WEST {
            runAction(actionFlip)
            direction = Compass.EAST
        }
    }
    
    func flipToWest() {
        if direction == Compass.EAST {
            runAction(actionFlip)
            direction = Compass.WEST
        }
    }
    
    func appear(delay: NSTimeInterval = 0.0, direction: Compass = Compass.EAST) {
        switch direction {
        case .WEST:
            self.direction = Compass.WEST
            runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), actionInstantFlip, SCNAction.unhide()]))
        default:
            runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.unhide()]))
        }
    }    
}
