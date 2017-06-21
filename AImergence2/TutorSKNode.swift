//
//  TutorSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 26/07/16.
//  CC0 No rights reserved.
//
//  The parent node that contains the tip help (green arrows)

enum Tutor { case instruction, command, score, replay, rank, drag, menu, redo, sequence, shape, color, level, resume, support, sound, done, instructionAgain, replayAgain, match, group}

import SpriteKit

class TutorSKNode: SKNode {
    
    
    var backgroundNode = SKShapeNode()
    var step = Tutor.command
    var commandTapped = [false, false]
    var level = 0
    
    override init() {
        
        super.init()
        self.zPosition = 8
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func tip(tutor: Tutor, parentNode: SKNode) {
        step = tutor
        removeFromParent()
        removeAllChildren()
        
        let tipMessage = message(tutor: tutor)
        self.position = tipMessage.position
        self.zRotation = tipMessage.zRotation
 
        backgroundNode = SKShapeNode(path: tipMessage.shape)
        //backgroundNode.lineWidth = 0
        backgroundNode.fillColor = UIColor(colorLiteralRed: 0.2, green: 0.7, blue: 0, alpha: 0.8)
        backgroundNode.strokeColor = UIColor(colorLiteralRed: 0.2, green: 0.7, blue: 0, alpha: 0.5)
        addChild(backgroundNode)
        
        let texts = tipMessage.text.components(separatedBy: "/")
        let lines = texts.count - 1
        let lineInterval = CGFloat(17 * 3)
        for line in 0...lines {
            let labelNode = SKLabelNode(text: texts[line])
            labelNode.fontName = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).fontName
            labelNode.fontSize = 34 // bodyFont.pointSize * 2
            labelNode.verticalAlignmentMode = .center
            labelNode.fontColor = UIColor.white
            labelNode.zPosition = 1
            labelNode.position = CGPoint(x: 0, y: lineInterval * (CGFloat(lines) / 2 - CGFloat(line)))
            addChild(labelNode)
        }
        parentNode.addChild(self)
    }
    
    func tapCommand(_ experimentNumber: Int, nextParentNode: SKNode ) {
        if level == 0 {
            if experimentNumber < commandTapped.count {
                commandTapped[experimentNumber] = true
            }
            if !commandTapped.contains(false) && step == .command {
                tip(tutor: .score, parentNode: nextParentNode)
            }
        }
        if level == 2 && step == .command {
            tip(tutor: .redo, parentNode: nextParentNode.scene!)
        }
        if level == 3 && step == .color {
            tip(tutor: .color, parentNode: nextParentNode.scene!)
        }
        if level == 100 {
            step = .done
            removeFromParent()
        }
    }
    
    func reachTen(_ nextParentNode: SKNode, level3ParentNode: SKNode) {
        if level == 0 {
            if step == .score || step == .command {
                tip(tutor: .replay, parentNode: nextParentNode)
            }
        }
        //if level == 3 {
        //    if step == .level {
        //        tip(tutor: .level, parentNode: level3ParentNode)
        //    }
        //}
    }
    
    func instructionClose(_ nextParentNode: SKNode, level1parentNode: SKNode) {
        if step == .instruction {
            tip(tutor: .instructionAgain, parentNode: nextParentNode)
        }
    }
    func instructionOk(_ nextParentNode: SKNode, level1parentNode: SKNode, levelLocked: Bool, levelLockedNode: SKNode) {
        if step == .instruction || step == .instructionAgain {
            if level == 0 {
                if levelLocked {
                    tip(tutor: .command, parentNode: nextParentNode)
                } else {
                    tip(tutor: .replay, parentNode: levelLockedNode)
                }
            } else {
                tip(tutor: .menu, parentNode: level1parentNode)
            }
        }
    }
    func replayClose(_ nextParentNode: SKNode) {
        if step == .replay || level == 1 {
            tip(tutor: .replayAgain, parentNode: nextParentNode)
        }
    }
    func replayOk(_ nextParentNode: SKNode) {
        if step == .replay || step == .replayAgain {
            tip(tutor: .rank, parentNode: nextParentNode)
        }
    }
    func gameCenterOk(_ nextParentNode: SKNode, level17ParentNode: SKNode) {
        if step == .rank {
            tip(tutor: .drag, parentNode: nextParentNode)
        }
        if level == 17 {
            tip(tutor: .support, parentNode: level17ParentNode)
        }
    }
    
    func tapRobot(_ nextParentNode: SKNode) {
        if level == 1 && step == .menu {
            step = .done
            removeFromParent()
        }
    }
    
    func tapEvent(_ nextParentNode: SKNode) {
        if level == 2 && step == .redo {
            tip(tutor: .sequence, parentNode: nextParentNode)
        }
    }
    
    func tapNextExperience() {
        if level == 2 && step == .sequence {
            step = .done
            removeFromParent()
        }
    }
    
    func longpressExperiment() {
        if level == 3 && step == .shape {
            step = .color
            removeFromParent()
        }
    }
    
    func longpressEvent() {
        if level == 3 && step == .color {
            step = .level
            removeFromParent()
        }
    }
    
    func arrive() {
        if (level == 3 && step == .level) || (level == 17 && step == .support) {
            step = .done
            removeFromParent()
        }
    }
    
    func matched(nextParentNode: SKNode) {
        if level == 100 {
            step = .done
            removeFromParent()
            tip(tutor: .command, parentNode: nextParentNode)
        }
    }
    
    func dragToResume(_ nextParentNode: SKNode) {
        tip(tutor: .resume, parentNode: nextParentNode)
    }
    
    func dragGroup(_ nextParentNode: SKNode) {
        tip(tutor: .group, parentNode: nextParentNode)
    }

    func message(tutor: Tutor) -> (text: String, shape: CGPath, position: CGPoint, zRotation: CGFloat) {
        let text: String
        let shape: CGPath
        let position: CGPoint
        let zRotation: CGFloat
        switch tutor {
        case .command:
            // 0
            text = NSLocalizedString("command", comment: "")
            shape = arrowRight(CGRect(x: -240, y: -60, width: 480, height: 120))
            position = CGPoint(x: -100, y: 460)
            zRotation = CGFloat(-1.2)
        case .score:
            // 1
            text = NSLocalizedString("score", comment: "")
            shape = arrowLeft(CGRect(x: -160, y: -60, width: 320, height: 120))
            position = CGPoint(x: 280, y: -100)
            zRotation = CGFloat(-0.3)
        case .instruction:
            // 2
            text = NSLocalizedString("instruction", comment: "")
            shape = arrowRight(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: -320, y: 0)
            zRotation = CGFloat(0)
        case .instructionAgain:
            text = NSLocalizedString("instructionAgain", comment: "")
            shape = arrowRight(CGRect(x: -230, y: -60, width: 460, height: 120))
            position = CGPoint(x: -350, y: 0)
            zRotation = CGFloat(0)
        case .replay:
            // 3
            text = NSLocalizedString("replay", comment: "")
            shape = arrowRight(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: -320, y: 0)
            zRotation = CGFloat(0)
        case .replayAgain:
            text = NSLocalizedString("replayAgain", comment: "")
            shape = arrowRight(CGRect(x: -230, y: -90, width: 460, height: 180))
            position = CGPoint(x: -350, y: 0)
            zRotation = CGFloat(0)
        case .rank:
            // 4
            text = NSLocalizedString("rank", comment: "")
            shape = arrowRight(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: -320, y: 0)
            zRotation = CGFloat(0)
        case .menu:
            // 5
            text = NSLocalizedString("menu", comment: "")
            shape = arrowRight(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: -320, y: 0)
            zRotation = CGFloat(0)
        case .drag:
            // 6
            text = NSLocalizedString("drag", comment: "")
            shape = arrowLeft(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: -280, y: 0)
            zRotation = CGFloat(0)
        case .redo:
            // 7
            text = NSLocalizedString("redo", comment: "")
            shape = arrowRight(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: -180, y: 600)
            zRotation = CGFloat(-1)
        case .shape:
            // 8
            text = NSLocalizedString("shape", comment: "")
            shape = arrowRight(CGRect(x: -240, y: -60, width: 480, height: 120))
            position = CGPoint(x: -140, y: 380)
            zRotation = CGFloat(-1.2)
        case .color:
            // 9
            text = NSLocalizedString("color", comment: "")
            shape = arrowRight(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: -180, y: 600)
            zRotation = CGFloat(-1)
        case .level:
            // 10
            text = NSLocalizedString("level", comment: "")
            shape = arrowRight(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: -300, y: -300)
            zRotation = CGFloat(0.9)
        case .sequence:
            // 11
            text = NSLocalizedString("sequence", comment: "")
            shape = arrowLeft(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: 290, y: 96)
            zRotation = CGFloat(0.3)
        case .resume:
            // 12
            text = NSLocalizedString("resume", comment: "")
            shape = arrowLeft(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: 0, y: 300)
            zRotation = CGFloat(Double.pi / 2)
        case .support:
            // 13
            text = NSLocalizedString("support", comment: "")
            shape = arrowRight(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: -300, y: -300)
            zRotation = CGFloat(0.9)
        case .sound, .done:
            // 14
            text = NSLocalizedString("sound", comment: "")
            shape = arrowLeft(CGRect(x: -220, y: -60, width: 440, height: 120))
            position = CGPoint(x: 300, y: -40)
            zRotation = CGFloat(-0.1)
        case .match:
            text = NSLocalizedString("match", comment: "")
            shape = arrowLeft(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: 250, y: 250)
            zRotation = CGFloat(Double.pi / 4)
        case .group:
            text = NSLocalizedString("group", comment: "")
            shape = arrowLeft(CGRect(x: -200, y: -60, width: 400, height: 120))
            position = CGPoint(x: 400, y: -550)
            zRotation = CGFloat(0)
        }
        return (text, shape, position, zRotation)
    }
}
func arrowLeft(_ rect: CGRect) -> CGPath {
    let offset = CGFloat(40)
    let radius = CGFloat (20)
    let path = CGMutablePath()
    path.move(to: CGPoint(x:rect.maxX, y: rect.minY + radius))
    path.addArc(tangent1End: CGPoint(x:rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX, y:rect.maxY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX - offset, y:0), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.minX - offset, y: 0), tangent2End: CGPoint(x: rect.minX, y:rect.minY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.minX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y:rect.minY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y:rect.maxY), radius: radius)
    path.closeSubpath();
    return path
}

func arrowRight(_ rect: CGRect) -> CGPath {
    let offset = CGFloat(40)
    let radius = CGFloat (20)
    let path = CGMutablePath()
    path.move(to: CGPoint(x:rect.minX, y: rect.minY + radius))
    path.addArc(tangent1End: CGPoint(x:rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.maxX, y:rect.maxY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.maxX + offset, y:0), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.maxX + offset, y: 0), tangent2End: CGPoint(x: rect.maxX, y:rect.minY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.minX, y:rect.minY), radius: radius)
    path.addArc(tangent1End: CGPoint(x:rect.minX, y: rect.minY), tangent2End: CGPoint(x: rect.minX, y:rect.maxY), radius: radius)
    path.closeSubpath();
    return path
}
