//
//  ShapableNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  CC0 No rights reserved.
//

import SpriteKit

class ReshapableSKNode: SKShapeNode
{

    let rect:CGRect
    let gameModel: GameModel0
    var shapeIndex:Int { return 0}
    
    init(rect: CGRect = CGRect(), gameModel: GameModel0) {
        self.rect = rect
        self.gameModel = gameModel
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reshape() {
        self.path = gameModel.experimentPaths[shapeIndex](rect).cgPath
    }
}

