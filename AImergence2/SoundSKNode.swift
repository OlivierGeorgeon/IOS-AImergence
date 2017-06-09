//
//  SoundSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 03/08/16.
//  CC0 No rights reserved.
//

import SpriteKit

class SoundSKNode: SKNode {

    let backgroundNode = SKSpriteNode(imageNamed: "speaker-black")
    let textureEnabled = SKTexture(imageNamed: "speaker-color")
    let textureDisabled = SKTexture(imageNamed: "speaker-black")

    override init() {
        super.init()
        
        position = CGPoint(x: 60, y: 1280)
        addChild(backgroundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle(_ soundEnabled: Bool) {
        if soundEnabled {
            backgroundNode.texture = textureEnabled
        } else {
            backgroundNode.texture = textureDisabled
        }
    }
}
