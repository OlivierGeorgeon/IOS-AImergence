//
//  ShapableNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ReshapableNode: SKShapeNode
{

    static let paths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle ]
    static let actionReshape = SKAction.customActionWithDuration(0, actionBlock: changeShape)

    var shapeIndex:Int {return 0}
    var rect:CGRect {return CGRect()}

    func reshape() {
        self.path = ReshapableNode.paths[shapeIndex](rect).CGPath
    }
}

private func changeShape(node: SKNode, elapsedTime:CGFloat) -> Void {
    if let shapeNode = node as? ReshapableNode {
        shapeNode.reshape()
    }
}

private func triangle(rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x:0, y: rect.minY))
    path.closePath()
    return path
}

