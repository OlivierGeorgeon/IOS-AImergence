//
//  ShapableNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ReshapableSKNode: SKShapeNode
{

    static let paths = [{UIBezierPath(ovalInRect: $0)},{UIBezierPath(rect: $0)}, triangle ]

    var rect:CGRect
    var shapeIndex:Int { return 0}
    
    init(rect: CGRect = CGRect()) {
        self.rect = rect
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reshape() {
        self.path = ReshapableSKNode.paths[shapeIndex](rect).CGPath
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

