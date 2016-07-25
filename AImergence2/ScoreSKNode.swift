//
//  ScoreSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ScoreSKNode: SKNode
{
    let titleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let labelNode = SKLabelNode(text: "0")
    let backgroundNode = SKShapeNode(rect: CGRect(x: -30, y: -30, width: 60, height: 60), cornerRadius: 20)
    let lineNode: SKShapeNode
    let moveNode = SKNode()
    let moveLabelNode = SKLabelNode(text: NSLocalizedString("0 moves", comment: "Init move count display"))
    let moveBackgroundNode = SKShapeNode(rect: CGRect(x: -110, y: -20, width: 220, height: 40), cornerRadius: 20)
    let gaugeNode = SKNode()
    let textWon = NSLocalizedString("Won in", comment: "You won in the main window");
    let textMoves = NSLocalizedString("moves", comment: "Number of moves displayed in the main window");

    override init() {
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        self.lineNode = SKShapeNode(path:pathToDraw)

        super.init()
        
        zPosition = -1
        
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
        
        moveNode.position = CGPoint(x: 150, y: 0)
        moveNode.zPosition = 10
        moveLabelNode.fontName = bodyFont.fontName
        moveLabelNode.fontSize = bodyFont.pointSize
        moveLabelNode.verticalAlignmentMode = .Center
        moveLabelNode.fontColor = UIColor.darkGrayColor()
        moveNode.addChild(moveLabelNode)
        moveBackgroundNode.zPosition = -1
        moveBackgroundNode.fillColor = UIColor.whiteColor()
        moveBackgroundNode.lineWidth = 0
        moveNode.hidden = true
        moveNode.addChild(moveBackgroundNode)
        addChild(moveNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(score: Int, clock: Int, winMoves: Int) {
        labelNode.text = "\(score)"
        if score >= 10 {
            backgroundNode.fillColor = UIColor.greenColor()
            lineNode.strokeColor = UIColor.greenColor()
        } else {
            if winMoves > 0 {
                backgroundNode.fillColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
                lineNode.strokeColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            } else {
                backgroundNode.fillColor = UIColor.whiteColor()
                lineNode.strokeColor = UIColor.whiteColor()
            }
        }
        gaugeNode.removeAllChildren()
        createGauge(score)
        
        moveBackgroundNode.fillColor = self.backgroundNode.fillColor
        if winMoves > 0 {
            moveLabelNode.text = "\(textWon) \(winMoves) \(textMoves)!"
        } else {
            moveLabelNode.text = "\(clock) \(textMoves)"
        }
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
}