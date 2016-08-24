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
    //let titleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    //let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let labelNode = SKLabelNode(text: "0")
    let backgroundNode = SKShapeNode(rect: CGRect(x: -60, y: -60, width: 120, height: 120), cornerRadius: 40)
    let lineNode: SKShapeNode
    let moveNode = SKNode()
    let moveLabelNode = SKLabelNode(text: NSLocalizedString("0 moves", comment: "Init move count display"))
    let moveBackgroundNode = SKShapeNode(rect: CGRect(x: -220, y: -40, width: 440, height: 80), cornerRadius: 40)
    let gaugeNode = SKNode()
    let textWon = NSLocalizedString("Won in", comment: "You won in the main window");
    let textMoves = NSLocalizedString("moves", comment: "Number of moves displayed in the main window");
    
    override init() {
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        self.lineNode = SKShapeNode(path:pathToDraw)

        super.init()
        
        zPosition = -1
        
        labelNode.fontName = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1).fontName
        labelNode.fontSize = 60 //titleFont.pointSize * 2
        labelNode.verticalAlignmentMode = .Center
        labelNode.fontColor = UIColor.darkGrayColor()
        addChild(labelNode)

        self.position = CGPoint(x: -234, y: 1004)
        backgroundNode.zPosition = -1
        backgroundNode.lineWidth = 1
        backgroundNode.name = "scoreBackground"
        backgroundNode.fillColor = UIColor.whiteColor()
        addChild(backgroundNode)
        
        CGPathMoveToPoint(pathToDraw, nil, 0, 0)
        CGPathAddLineToPoint(pathToDraw, nil, 356, 0)
        self.lineNode.path = pathToDraw
        self.lineNode.strokeColor = SKColor.whiteColor()
        self.lineNode.zPosition = -2
        self.lineNode.hidden = true
        self.lineNode.lineWidth = 2
        addChild(self.lineNode)
        
        gaugeNode.position = CGPoint(x: -100, y: -80)
        addChild(gaugeNode)
        createGauge(0)
        
        moveNode.position = CGPoint(x: 300, y: 0)
        moveNode.zPosition = 10
        moveLabelNode.fontName = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontName
        moveLabelNode.fontSize = 34
        moveLabelNode.verticalAlignmentMode = .Center
        moveLabelNode.fontColor = UIColor.darkGrayColor()
        moveNode.addChild(moveLabelNode)
        moveBackgroundNode.zPosition = -1
        moveBackgroundNode.fillColor = UIColor.whiteColor()
        //moveBackgroundNode.lineWidth = 0
        moveNode.hidden = true
        moveNode.addChild(moveBackgroundNode)
        addChild(moveNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(score: Int, clock: Int, winMoves: Int) {
        labelNode.text = "\(score)"
        let scoreColor: UIColor
        if score >= 10 {
            scoreColor = UIColor.greenColor()
        } else {
            if winMoves > 0 {
                scoreColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            } else {
                scoreColor = UIColor.whiteColor()
            }
        }
        backgroundNode.fillColor = scoreColor
        backgroundNode.strokeColor = scoreColor
        lineNode.strokeColor = scoreColor
        gaugeNode.removeAllChildren()
        createGauge(score)
        
        moveBackgroundNode.fillColor = scoreColor
        moveBackgroundNode.strokeColor = scoreColor
        if winMoves > 0 {
            moveLabelNode.text = "\(textWon) \(winMoves) \(textMoves)!"
        } else {
            moveLabelNode.text = "\(clock) \(textMoves)"
        }
    }

    func createGauge(score: Int) {
        var y = -140
        var height = 280
        if score < -10 {
            y = score * 12 - 20
            height = -score * 12 + 160
        }
        if score > 10 {
            height = score * 12 + 160
        }
        let gaugeBackgroundNode = SKShapeNode(rect: CGRect(x: -6, y: y, width: 20, height: height), cornerRadius: 10)
        gaugeBackgroundNode.zPosition = -1
        gaugeBackgroundNode.lineWidth = 2
        gaugeNode.addChild(gaugeBackgroundNode)
        
        if score > 0 {
            for i in 1...score {
                let dotNode = SKShapeNode(rect: CGRect(x: -2, y: i * 12, width: 12, height: 8))
                dotNode.fillColor = UIColor.greenColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
        if score < 0 {
            for i in 1...(-score) {
                let dotNode = SKShapeNode(rect: CGRect(x: -2, y: -i * 12, width: 12, height: 8))
                dotNode.fillColor = UIColor.redColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
    }
    
}