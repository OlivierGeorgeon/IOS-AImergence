//
//  TutorSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 26/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class TutorSKNode: SKNode {
    
    static var test = 0
    
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let shapeFuncs = [arrowRight, arrowLeft, arrowRight, arrowRight, arrowRight, arrowRight, arrowRight, arrowRight, arrowRight, arrowRight, arrowRight]

    let tips = [NSLocalizedString("Tip0", comment: ""),
                NSLocalizedString("Tip1", comment: ""),
                NSLocalizedString("Tip2", comment: ""),
                NSLocalizedString("Tip3", comment: ""),
                NSLocalizedString("Tip4", comment: ""),
                NSLocalizedString("Tip5", comment: ""),
                NSLocalizedString("Tip6", comment: ""),
                NSLocalizedString("Tip7", comment: ""),
                NSLocalizedString("Tip8", comment: ""),
                NSLocalizedString("Tip9", comment: ""),
                NSLocalizedString("Tip10", comment: "")]
    
    let tipRects = [CGRect(x: -110, y: -30, width: 220, height: 60),
                    CGRect(x: -80, y: -30, width: 160, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -120, y: -30, width: 240, height: 60),
                    CGRect(x: -100, y: -30, width: 200, height: 60),
                    CGRect(x: -116, y: -30, width: 232, height: 60),
                    CGRect(x: -116, y: -30, width: 232, height: 60)]
    
    let tipPositions = [CGPoint(x: -50, y: 230),
                        CGPoint(x: 150, y: -50),
                        CGPoint(x: -170, y: 0),
                        CGPoint(x: -170, y: 0),
                        CGPoint(x: -170, y: 0),
                        CGPoint(x: -170, y: 0),
                        CGPoint(x: -170, y: 0),
                        CGPoint(x: -100, y: 280),
                        CGPoint(x: -70, y: 150),
                        CGPoint(x: -100, y: 280),
                        CGPoint(x: -50, y: 200)]
    
    let tipzRotations = [CGFloat(-1.2), CGFloat(-0.3), CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(-1), CGFloat(-0.7), CGFloat(-1), CGFloat(0.9)]
    
    var backgroundNode = SKShapeNode()
    var step = 0
    var commandTapped = [false, false]
    var level = 0
    
    override init() {
        
        super.init()
    
        self.zPosition = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tip(i: Int, parentNode: SKNode) {
        step = i
        removeFromParent()
        removeAllChildren()
        position = tipPositions[i]
        zRotation = tipzRotations[i]
        
        backgroundNode = SKShapeNode(path: shapeFuncs[i](tipRects[i]).CGPath)
        backgroundNode.lineWidth = 3
        backgroundNode.strokeColor = UIColor(colorLiteralRed: 0, green: 0.5, blue: 0, alpha: 1)
        backgroundNode.fillColor = UIColor(colorLiteralRed: 0.5, green: 1.0, blue: 0.5, alpha: 0.5)
        addChild(backgroundNode)
        
        let texts = tips[i].componentsSeparatedByString("/")
        let lines = texts.count - 1
        let lineInterval = bodyFont.pointSize * 1.5
        for line in 0...lines {
            let labelNode = SKLabelNode(text: texts[line])
            labelNode.fontName = bodyFont.fontName
            labelNode.fontSize = bodyFont.pointSize
            labelNode.verticalAlignmentMode = .Center
            labelNode.fontColor = UIColor.blackColor()
            labelNode.zPosition = 1
            labelNode.position = CGPoint(x: 0, y: lineInterval * (CGFloat(lines) / 2 - CGFloat(line)))
            addChild(labelNode)
        }
        parentNode.addChild(self)
    }
    
    func tapCommand(experimentNumber: Int, nextParentNode: SKNode ) {
        if level == 0 {
            if experimentNumber < commandTapped.count {
                commandTapped[experimentNumber] = true
            }
            if !commandTapped.contains(false) && step == 0 {
                tip(1, parentNode: nextParentNode)
            }
        }
        if level == 2 && step == 0 {
            tip(7, parentNode: nextParentNode.scene!)
        }
        if level == 3 && step == 9 {
            tip(9, parentNode: nextParentNode.scene!)
        }
    }
    
    func reachTen(nextParentNode: SKNode) {
        if level == 0 {
            if step == 1 || step == 0 {
                tip(2, parentNode: nextParentNode)
            }
        }
        if level == 3 {
            if step == 10 {
                tip(10, parentNode: nextParentNode.parent!)
            }
        }
    }
    
    func instructionOk(nextParentNode: SKNode) {
        if step == 2 {
            if level == 0 {
                tip(3, parentNode: nextParentNode)
            } else {
                tip(5, parentNode: nextParentNode.parent!)
            }
        }
    }
    func robotOk(nextParentNode: SKNode) {
        if step == 3 {
            tip(4, parentNode: nextParentNode)
        }
    }
    func gameCenterOk(nextParentNode: SKNode) {
        if step == 4 {
            tip(6, parentNode: nextParentNode)
        }
    }
    
    func tapRobot(nextParentNode: SKNode) {
        if level == 1 && step == 5 {
            step = 100
            removeFromParent()
        }
    }
    
    func tapEvent(nextParentNode: SKNode) {
        if level == 2 && step == 7 {
            step = 100
            removeFromParent()
        }
    }
    
    func longpressExperiment() {
        if level == 3 && step == 8 {
            step = 9
            removeFromParent()
        }
    }
    
    func longpressEvent() {
        if level == 3 && step == 9 {
            step = 10
            removeFromParent()
        }
    }
    
    func arrive() {
        if level == 3 && step == 10 {
            step = 100
            removeFromParent()
        }
    }
}

func arrowLeft(rect: CGRect) -> UIBezierPath {
    let offset = CGFloat(20)
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.minX , y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.minX - offset, y: 0))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.closePath()
    return path
}

func arrowRight(rect: CGRect) -> UIBezierPath {
    let offset = CGFloat(20)
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
    path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLineToPoint(CGPoint(x: rect.maxX + offset, y: 0))
    path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.minY))
    path.closePath()
    return path
}
