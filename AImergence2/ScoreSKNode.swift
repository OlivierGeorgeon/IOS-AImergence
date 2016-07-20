//
//  ScoreSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreSKNode: SKNode
{
    let titleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let labelNode = SKLabelNode(text: "0")
    let backgroundNode = SKShapeNode(rect: CGRect(x: -30, y: -30, width: 60, height: 60), cornerRadius: 20)
    let lineNode: SKShapeNode
    let gaugeNode = SKNode()
    
    var won = false

    override init() {
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        self.lineNode = SKShapeNode(path:pathToDraw)

        super.init()
        
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize
        labelNode.verticalAlignmentMode = .Center
        labelNode.fontColor = UIColor.darkGrayColor()// blackColor()
        addChild(labelNode)

        self.position = CGPoint(x: -117, y: 502)
        backgroundNode.zPosition = -1
        backgroundNode.lineWidth = 0
        backgroundNode.name = "scoreBackground"
        backgroundNode.fillColor = UIColor.whiteColor()
        addChild(backgroundNode)
        
        CGPathMoveToPoint(pathToDraw, nil, 0, 0)
        CGPathAddLineToPoint(pathToDraw, nil, 178, 0)
        self.lineNode.path = pathToDraw
        self.lineNode.strokeColor = SKColor.whiteColor()
        self.lineNode.zPosition = -2
        self.lineNode.hidden = true
        addChild(self.lineNode)
        
        gaugeNode.position = CGPoint(x: -50, y: -40)
        addChild(gaugeNode)
        createGauge(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(score: Int) {
        labelNode.text = "\(score)"
        if score >= 10 {
            backgroundNode.fillColor = UIColor.greenColor()
            lineNode.strokeColor = UIColor.greenColor()
            won = true
        } else {
            if won {
                backgroundNode.fillColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
                lineNode.strokeColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            } else {
                backgroundNode.fillColor = UIColor.whiteColor()
                lineNode.strokeColor = UIColor.whiteColor()
            }
        }
        gaugeNode.removeAllChildren()
        createGauge(score)
    }

    func createGauge(score: Int) {
        var y = -70
        var height = 140
        if score < -10 {
            y = score * 6 - 10
            height = -score * 6 + 80
        }
        if score > 10 {
            height = score * 6 + 80
        }
        let gaugeBackgroundNode = SKShapeNode(rect: CGRect(x: -3, y: y, width: 10, height: height), cornerRadius: 5)
        gaugeBackgroundNode.zPosition = -1
        //gaugeBackgroundNode.fillColor = UIColor.whiteColor()
        gaugeBackgroundNode.lineWidth = 1
        gaugeNode.addChild(gaugeBackgroundNode)
        
        if score > 0 {
            for i in 1...score {
                let dotNode = SKShapeNode(rect: CGRect(x: -1, y: i * 6, width: 6, height: 4))
                dotNode.fillColor = UIColor.greenColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
        if score < 0 {
            for i in 1...(-score) {
                let dotNode = SKShapeNode(rect: CGRect(x: -1, y: -i * 6, width: 6, height: 4))
                dotNode.fillColor = UIColor.redColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
    }
    
    func createMoveNode(moves: Int, won: Bool) -> SKNode {
        let moveNode = SKNode()
        moveNode.position = CGPoint(x: -50, y: 502)
        
        let textWon = NSLocalizedString("Won in", comment: "You won in the main window");
        let textMoves = NSLocalizedString("moves", comment: "Number of moves displayed in the main window");
        
        let labelNode = SKLabelNode()
        if won {
            labelNode.text = "\(textWon) \(moves) \(textMoves)!"
        } else {
            labelNode.text = "\(moves) \(textMoves)"
        }
        
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize
        labelNode.verticalAlignmentMode = .Center
        labelNode.fontColor = UIColor.darkGrayColor()
        moveNode.addChild(labelNode)
        
        let backgroundNode = SKShapeNode(rect: CGRect(x: -100, y: -30, width: 200, height: 60), cornerRadius: 20)
        backgroundNode.zPosition = -1
        backgroundNode.lineWidth = 0
        backgroundNode.fillColor = self.backgroundNode.fillColor
        moveNode.addChild(backgroundNode)
        
        return moveNode
    }
}