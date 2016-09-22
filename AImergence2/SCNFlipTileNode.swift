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
 
    let tailNode = SCNNode()
    let actionFlipClockwise = SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat(M_PI) , duration: 0.2)
    let actionFlipCounterclockwise = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(M_PI) , duration: 0.2)

    var direction = Compass.north
    var tailColor = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
    
    override init() {
        super.init()
        //self.hidden = true in super.init()
    }
    
    convenience init(color: UIColor?, direction: Compass = .north) {
        self.init()

        let grayMaterial = SCNMaterial()
        grayMaterial.diffuse.contents = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        grayMaterial.specular.contents = UIColor.white

        let colorMaterial = SCNMaterial()
        if color == nil {
            colorMaterial.diffuse.contents = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        } else {
            colorMaterial.diffuse.contents = color!
        }
        colorMaterial.specular.contents = UIColor.white

        let headGeometry = SCNBox(width: 10, height: 2, length: 10, chamferRadius: 1)
        headNode.geometry = headGeometry

        let path = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100) , cornerRadius: 10)
        let tailGeometry = SCNShape(path: path, extrusionDepth: CGFloat(10))
        tailNode.geometry = tailGeometry
        tailNode.scale = SCNVector3(0.1, 0.1, 0.1)
        tailNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 1, 0, 0)

        self.direction = direction
        if direction == .north {
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
    
    func appearAndFlip(_ clockwise: Bool = true, delay: TimeInterval = 0) {
        let actionWait = SCNAction.wait(duration: delay)
        switch clockwise {
        case true:
            runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionFlipClockwise]))
        case false:
            runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionFlipCounterclockwise]))
        }
        swapDirection()
    }
    
    func appearAndFlipAndColorize(_ color: UIColor, clockwise: Bool = true, delay: TimeInterval = 0) {
        let actionWait = SCNAction.wait(duration: delay)
        let actionColorize: SCNAction
        switch direction {
        case .north:
            tailColor = color
            direction = .south
            actionColorize = SCNAction.run(colorizeTailBloc)
        default:
            headColor = color
            direction = .north
            actionColorize = SCNAction.run(colorizeHeadBloc)
        }
        switch clockwise {
        case true:
            runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionColorize, actionFlipClockwise]))
        case false:
            runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionColorize, actionFlipCounterclockwise]))
        }
    }
    
    override func colorize(_ color: UIColor, delay: TimeInterval = 0.0) {
        let actionWait = SCNAction.wait(duration: delay)
        let actionColorize: SCNAction
        switch direction {
        case .north:
            headColor = color
            actionColorize = SCNAction.run(colorizeHeadBloc)
        default:
            tailColor = color
            actionColorize = SCNAction.run(colorizeTailBloc)
        }
        runAction(SCNAction.sequence([actionWait, actionColorize]))
    }

    func colorizeAndFlip(_ color: UIColor, clockwise: Bool = true, delay: TimeInterval = 0.0) {
        let actionWait = SCNAction.wait(duration: delay)
        let actionColorize: SCNAction
        switch direction {
        case .north:
            headColor = color
            actionColorize = SCNAction.run(colorizeHeadBloc)
            direction = .south
        default:
            tailColor = color
            actionColorize = SCNAction.run(colorizeTailBloc)
            direction = .north
        }
        switch clockwise {
        case true:
            runAction(SCNAction.sequence([actionWait, actionFlipClockwise, actionColorize]))
        case false:
            runAction(SCNAction.sequence([actionWait, actionFlipCounterclockwise, actionColorize]))
        }
    }
    
    func flipAndColorize(_ color: UIColor, clockwise: Bool = true, delay: TimeInterval = 0.0) {
        let actionWait = SCNAction.wait(duration: delay)
        let actionColorize: SCNAction
        switch direction {
        case .north:
            tailColor = color
            direction = .south
            actionColorize = SCNAction.run(colorizeTailBloc)
        default:
            headColor = color
            direction = .north
            actionColorize = SCNAction.run(colorizeHeadBloc)
        }
        switch clockwise {
        case true:
            runAction(SCNAction.sequence([actionWait, actionFlipClockwise, actionColorize]))
        case false:
            runAction(SCNAction.sequence([actionWait, actionFlipCounterclockwise, actionColorize]))
        }
    }
    
    func colorizeTailBloc(_ node: SCNNode) {
        if let flipTileNode  = node as? SCNFlipTileNode {
            flipTileNode.tailNode.geometry!.firstMaterial!.diffuse.contents = flipTileNode.tailColor
        }
    }

    func flip(_ clockwise: Bool = true, delay: TimeInterval = 0) {
        let actionWait = SCNAction.wait(duration: delay)
        switch clockwise {
        case true:
            runAction(SCNAction.sequence([actionWait, actionFlipClockwise]))
        case false:
            runAction(SCNAction.sequence([actionWait, actionFlipCounterclockwise]))
        }
        swapDirection()
    }
    
    override func color() -> UIColor {
        let topNode: SCNNode
        switch direction {
        case .north:
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
    
    override func hideChildren() {
        headNode.isHidden = true
        tailNode.isHidden = true
    }
    
    func swapDirection() {
        switch direction {
        case .north:
            direction = .south
        default:
            direction = .north
        }
    }
}
