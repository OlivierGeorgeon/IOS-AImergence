//
//  MatchSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 26/07/16.
//  CC0 No rights reserved.
//
//  The node that represent the remote player

import Foundation
import SpriteKit
import GameKit

enum MatchStatus { case disconnected, connected }

class MatchSKNode: SKNode
{
    //let backgroundNode = SKShapeNode(rect: CGRect(x: -75, y: -75, width: 150, height: 150), cornerRadius: 20)
    let backgroundNode: SKSpriteNode // (imageNamed: "connect")
    let textureDisconnected = SKTexture(imageNamed: "connect")
    let textureConnected = SKTexture(imageNamed: "connect_blank")
    let labelNode = SKLabelNode(text: "")
    let levelNode = SKLabelNode(text: "")
    let colorDisconnected = UIColor(red: 110/255, green: 120/255, blue: 140/255, alpha: 1)
    let colorConnected = UIColor(red: 110/255, green: 120/255, blue: 140/255, alpha: 1)
    
    var matchStatus = MatchStatus.disconnected
    
    override init() {
        
        backgroundNode = SKSpriteNode(texture: textureDisconnected)
        
        super.init()
        
        position = CGPoint(x: -220, y: 345)
        
        backgroundNode.zPosition = -1
        addChild(backgroundNode)

        labelNode.fontName = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1).fontName
        labelNode.fontSize = 60
        labelNode.verticalAlignmentMode = .center
        labelNode.fontColor = UIColor.white
        addChild(labelNode)

        levelNode.fontName = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).fontName
        levelNode.fontSize = 20
        levelNode.verticalAlignmentMode = .center
        levelNode.fontColor = UIColor.white
        levelNode.position = CGPoint(x:0 , y: -50)
        addChild(levelNode)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(status: MatchStatus) {
        self.matchStatus = status
        
        switch status {
        case .connected:
            backgroundNode.texture = textureConnected
        default:
            backgroundNode.texture = textureDisconnected
        }
    }
    
    func update(displayName: String?) {
        var initials = ""
        if displayName != nil {
            if displayName!.characters.count > 0 {
                initials = String(displayName![displayName!.startIndex])
                let displayNameArray = displayName!.components(separatedBy: " ")
                if displayNameArray.count > 1 {
                    initials += String(displayNameArray.last![displayNameArray.last!.startIndex])
                }
            }
        }
        labelNode.text = initials
    }
    
    func update(text: String) {
        levelNode.text = text
    }
}
