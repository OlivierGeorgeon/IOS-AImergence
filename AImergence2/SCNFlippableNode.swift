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

        let blueMaterial = SCNMaterial()
        blueMaterial.diffuse.contents = UIColor(red: 140/256, green: 133/256, blue: 190/256, alpha: 1)
        blueMaterial.specular.contents = UIColor.whiteColor()

        let greenMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = UIColor.greenColor()
        greenMaterial.specular.contents = UIColor.whiteColor()
        
        let sphereGeometry = SCNSphere(radius: 0.5 * 10)
        sphereGeometry.materials = [greenMaterial]
        let sphere = SCNNode(geometry: sphereGeometry)
        pawnNode.addChildNode(sphere)

        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.redColor()
        redMaterial.specular.contents = UIColor.whiteColor()
        
        let halfCylinderGeometry = SCNCylinder(radius: 0.5 * 10, height: 0.5 * 10)
        halfCylinderGeometry.materials = [redMaterial]
        let halfCylinder = SCNNode(geometry: halfCylinderGeometry)
        halfCylinder.position = SCNVector3(0, -2.5 , 0)
        pawnNode.addChildNode(halfCylinder)
        
        pawnNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        addChildNode(pawnNode.flattenedClone())
        //addChildNode(pawnNode)
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
    
    func appear(delay: NSTimeInterval = 0.0, direction: Compass = Compass.EAST, action: SCNAction =  SCNAction.unhide()) {
        switch direction {
        case .WEST:
            self.direction = Compass.WEST
            runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), actionInstantFlip, SCNAction.unhide(), action]))
        default:
            runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.unhide(), action]))
        }
    }    
}
