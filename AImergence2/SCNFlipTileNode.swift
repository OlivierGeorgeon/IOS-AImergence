//
//  SCNFlipTileNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/08/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class SCNFlipTileNode: SCNPhenomenonNode {
 
    let headNode = SCNNode()
    let tailNode = SCNNode()

    var direction = Compass.NORTH
    
    override init() {
        super.init()
        self.hidden = true
    }
    
    convenience init(color: UIColor?, direction: Compass = .NORTH) {
        self.init()

        let grayMaterial = SCNMaterial()
        grayMaterial.diffuse.contents = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        grayMaterial.specular.contents = UIColor.whiteColor()

        let colorMaterial = SCNMaterial()
        if color == nil {
            colorMaterial.diffuse.contents = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        } else {
            colorMaterial.diffuse.contents = color!
        }
        colorMaterial.specular.contents = UIColor.whiteColor()

        let headGeometry = SCNBox(width: 10, height: 2, length: 10, chamferRadius: 1)
        headNode.geometry = headGeometry

        let path = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100) , cornerRadius: 10)
        let tailGeometry = SCNShape(path: path, extrusionDepth: CGFloat(10))
        tailNode.geometry = tailGeometry
        tailNode.scale = SCNVector3(0.1, 0.1, 0.1)
        tailNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 1, 0, 0)

        self.direction = direction
        if direction == .NORTH {
            headGeometry.materials = [colorMaterial]
            tailGeometry.materials = [grayMaterial]
            tailNode.position = SCNVector3(0, -0.55 , 0)
        } else {
            headGeometry.materials = [grayMaterial]
            tailGeometry.materials = [colorMaterial]
            tailNode.position = SCNVector3(0, 0.55 , 0)
        }

        //colorize(color)
        
        self.addChildNode(headNode)
        self.addChildNode(tailNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func colorize(color: UIColor, delay: NSTimeInterval = 0) {
        let colorizeBlock: (SCNNode) -> Void
        switch direction {
        case .NORTH:
            colorizeBlock = {
                ($0 as! SCNFlipTileNode).headNode.geometry!.firstMaterial!.diffuse.contents = color
            }
        default:
            colorizeBlock = {
                ($0 as! SCNFlipTileNode).tailNode.geometry!.firstMaterial!.diffuse.contents = color
            }
        }
        
        let actionWait = SCNAction.waitForDuration(delay)
        let actionColorize = SCNAction.runBlock(colorizeBlock)
        runAction(SCNAction.sequence([actionWait, actionColorize]))
    }
    
    func flipLeft(delay: NSTimeInterval = 0) {
        let actionFlipLeft = SCNAction.rotateByX(0, y: 0, z: CGFloat(M_PI) , duration: 0.2)
        runAction(SCNAction.sequence([SCNAction.waitForDuration(delay),actionFlipLeft]))
        switch direction {
        case .NORTH:
            direction = Compass.SOUTH
        default:
            direction = Compass.NORTH
        }
    }
    
    func flipRight(delay: NSTimeInterval = 0) {
        let actionFlipRight = SCNAction.rotateByX(0, y: 0, z: -CGFloat(M_PI) , duration: 0.2)
        runAction(SCNAction.sequence([SCNAction.waitForDuration(delay),actionFlipRight]))
        switch direction {
        case .NORTH:
            direction = Compass.SOUTH
        default:
            direction = Compass.NORTH
        }
    }
    
    func appear(delay: NSTimeInterval = 0) {
        runAction(SCNAction.sequence([SCNAction.waitForDuration(delay), SCNAction.unhide()]))
    }
    
    override func color() -> UIColor {
        let topNode: SCNNode
        switch direction {
        case .NORTH:
            topNode = headNode
        default:
            topNode = tailNode
        }
        if let color = topNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
            return color
        } else {
            return UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        }
    }
}