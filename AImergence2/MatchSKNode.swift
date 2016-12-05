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

enum MatchStatus { case disconnected, connected }

class MatchSKNode: SKNode
{
    let backgroundNode = SKShapeNode(rect: CGRect(x: -75, y: -75, width: 150, height: 150), cornerRadius: 10)
    
    var matchStatus = MatchStatus.disconnected
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -220, y: 360)
        backgroundNode.fillColor = UIColor.white
        addChild(backgroundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(status: MatchStatus) {
        self.matchStatus = status
        switch status {
        case .connected:
            backgroundNode.fillColor = UIColor.green
        default:
            backgroundNode.fillColor = UIColor.white
        }
    }
}
