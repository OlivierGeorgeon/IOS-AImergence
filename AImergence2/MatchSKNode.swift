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
    let backgroundNode = SKShapeNode(rect: CGRect(x: -100, y: -100, width: 200, height: 200), cornerRadius: 10)
    
    override init() {
        
        super.init()
        
        position = CGPoint(x: -100, y: 200)
        addChild(backgroundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showMatchMaker() {
        print("match making ......")
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = 2
        matchRequest.maxPlayers = 2
        matchRequest.defaultNumberOfPlayers = 2
        
        //let mmvc: GKMatchmakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)!
        //(self.scene!.view! as? GameView)?.delegate?.presentMatchMakingViewController(mmvc)
    }
}