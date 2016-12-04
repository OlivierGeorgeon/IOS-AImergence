//
//  MatchSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 26/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class MatchSKNode: SKNode
{
    let backgroundNode = SKShapeNode(rect: CGRect(x: -75, y: -75, width: 150, height: 150), cornerRadius: 10)
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -220, y: 360)
        backgroundNode.fillColor = UIColor.white
        addChild(backgroundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
