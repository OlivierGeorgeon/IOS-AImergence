//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit
import StoreKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

enum LevelStatus { case won, accessible, inaccessible}


protocol MenuSceneDelegate: class
{
    func currentLevel() -> Int
    func updateLevel(_ level: Int)
    func levelStatus(_ level: Int) -> LevelStatus
    func leaveTip(_ product: SKProduct)
    func isSoundEnabled() -> Bool
    func toggleSound() -> Bool
    func isUserHasDraggedLevel() -> Bool
    func userDragLevel()
}

class MenuSKScene: PositionedSKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "niveaux.png") 
    let originNode = SKNode()
    let levelGroupNode = SKNode()
    let tipInviteNode = SKLabelNode()
    let tutorNode = TutorSKNode()
    let soundNode = SoundSKNode()
    let level0Position = CGPoint(x: 120, y: 1100)
    let levelXOffset =  120
    let levelYOffset = -160
    let levelGroupXOffset = 650
    let levelGroupYOffset = 4 * 160
    let thankYou = NSLocalizedString("Thank you!", comment: "In the level window when the user has paid a tip.")
    let tip0Node = TipSKNode(size: CGSize(width: 140, height: 140))
    let tip1Node = TipSKNode(size: CGSize(width: 160, height: 160))
    let tip2Node = TipSKNode(size: CGSize(width: 160, height: 160))

    weak var userDelegate: MenuSceneDelegate?

    var shortTipInvit = NSLocalizedString("Connect", comment: "In the level window when there is no network connection.")
    var longTipInvit = NSLocalizedString("Connect", comment: "In the level window when there is no network connection.")
    var buttonNodes = [SKNode]()
    var previousGameScene:GameSKScene?
    var levelGroupIndex = 0
    var verticalPan = true

    override func didMove(to view: SKView)
    {
        /* Setup your scene here */

        addChild(originNode)
        originNode.addChild(levelGroupNode)
        
        levelGroupIndex = userDelegate!.currentLevel() / 20
        levelGroupNode.position = level0Position
        tutorNode.level = userDelegate!.currentLevel()
        if !userDelegate!.isUserHasDraggedLevel() {
            tutorNode.dragToResume(tipInviteNode)
        }
        backgroundColor = UIColor.white
        backgroundNode.size = CGSize(width: 1334, height: 1334)
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        originNode.addChild(backgroundNode)
        
        soundNode.toggle(userDelegate!.isSoundEnabled())
        addChild(soundNode)

        buttonNodes = createButtons(view.frame.size)
        
        tipInviteNode.fontName = bodyFont.fontName
        tipInviteNode.fontSize = 56
        tipInviteNode.fontColor = UIColor.darkGray
        tipInviteNode.verticalAlignmentMode = .center
        originNode.addChild(tipInviteNode)

        originNode.addChild(tip0Node)
        originNode.addChild(tip1Node)
        originNode.addChild(tip2Node)

        super.didMove(to: view)
        
        if self.size.width < CGFloat(levelGroupXOffset) * 2 {
            levelGroupNode.position.x -= CGFloat(levelGroupXOffset * levelGroupIndex)
        }
    }
    
    func displayProducts(_ products: [SKProduct], isPaidTip: Bool) {
        if products.count > 0 {
            shortTipInvit =  products[0].localizedDescription
            tip0Node.product(products[0])
            if products.count > 1 {
                longTipInvit =  products[1].localizedDescription
                tip1Node.product(products[1])
                if products.count > 2 {
                    tip2Node.product(products[2])
                }
            }
        }
        if isPaidTip {
            shortTipInvit = thankYou
            longTipInvit = shortTipInvit
        }
        if self.size.height >= self.size.width {
            tipInviteNode.text = shortTipInvit
        } else {
            tipInviteNode.text = longTipInvit
        }
        tipInviteNode.fontSize = 56
        // May be called before self.size is initialized. In that case it will be reset by positionInFrame.
        while tipInviteNode.frame.size.width >= self.size.width - 10 && tipInviteNode.fontSize > 10 {
            tipInviteNode.fontSize -= 1.0
        }
    }
    
    override func positionInFrame(_ frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            backgroundNode.position = CGPoint(x: 600, y: 600)
            tipInviteNode.text = shortTipInvit
            tip0Node.position = CGPoint(x: size.width / 2 - 200, y: 260)
            tip1Node.position = CGPoint(x: size.width / 2 - 20, y: 140)
            tip2Node.position = CGPoint(x: size.width / 2 + 200, y: 210)
        } else {
            backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            tipInviteNode.text = longTipInvit
            tip0Node.position = CGPoint(x: size.width / 2 - 340, y: 260)
            tip1Node.position = CGPoint(x: size.width / 2, y: 140)
            tip2Node.position = CGPoint(x: size.width / 2 + 340, y: 210)
        }
        
        tipInviteNode.position = CGPoint(x: self.size.width / 2, y: 420)
        tipInviteNode.fontSize = 56 // titleFont.pointSize * 2
        while tipInviteNode.frame.size.width >= self.size.width - 10 && tipInviteNode.fontSize > 10  {
            tipInviteNode.fontSize -= 1.0
        }
    }
    
    func createButtons(_ frameSize: CGSize) -> [SKNode]
    {
        var buttonNodes = [SKNode]()
        for i in 0...GameViewController.maxLevelNumber {
            let levelNode = createLabelNode("\(i)")
            levelNode.fontName = "Noteworthy-Bold"
            levelNode.userData = ["level": i]
            //levelNode.position = level0Position + (i % 5) * levelXOffset + (i / 5) * levelYOffset
            levelNode.position = CGPoint(x: (i % 5) * levelXOffset + (i / 20) * levelGroupXOffset,
                                         y: (i / 5) * levelYOffset + (i / 20) * levelGroupYOffset)
            buttonNodes.append(levelNode)
            levelGroupNode.addChild(levelNode)
            
            var backgroundNode = SKShapeNode()
            switch userDelegate!.levelStatus(i) {
            case .accessible:
                backgroundNode = SKShapeNode(rect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 30)
            case .won:
                backgroundNode = SKShapeNode(rect: CGRect(x: -50, y: -50, width: 100, height: 100))
            case .inaccessible:
                backgroundNode = SKShapeNode(path: UIBezierPath(ovalIn: CGRect(x: -50, y: -50, width: 100, height: 100)).cgPath)
            }
            
            let buttonColor: UIColor
            if i == userDelegate?.currentLevel() {
                buttonColor = UIColor(red: 114 / 256, green: 114 / 256, blue: 171 / 256, alpha: 1)
            } else  {
                buttonColor = UIColor(red: 150 / 256, green: 100 / 256, blue: 150 / 256, alpha: 1)
            }
            backgroundNode.fillColor = buttonColor
            backgroundNode.strokeColor = buttonColor
            levelNode.addChild(backgroundNode)
        }
        return buttonNodes
    }
    
    func createLabelNode(_ text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize * 2
        labelNode.fontColor = UIColor.white
        labelNode.verticalAlignmentMode = .center
        return labelNode
    }

    override func pan(_ recognizer: UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.view!)
        let velocity = recognizer.velocity(in: self.view!)
        switch recognizer.state {
        case .began:
            verticalPan = abs(velocity.x) < abs(velocity.y)
        case .changed:
            if verticalPan {
                originNode.position.y -= translation.y * sceneHeight / self.view!.frame.height
            } else {
                levelGroupNode.position.x += translation.x * self.size.width / self.view!.frame.width
            }
        case .ended:
            if verticalPan {
                if velocity.y > 200 {
                    self.view!.presentScene(previousGameScene!, transition: transitionDown)
                    userDelegate!.userDragLevel()
                } else {
                    let moveToOrigin = SKAction.move(to: CGPoint.zero, duration: 0.2)
                    moveToOrigin.timingMode = .easeInEaseOut
                    originNode.run(moveToOrigin)
                }
            } else {
                if velocity.x > 0 {
                    if levelGroupIndex > 0
                    {
                        levelGroupIndex -= 1
                    }
                } else {
                    if levelGroupIndex < GameViewController.maxLevelNumber / 20
                    {
                        levelGroupIndex += 1
                    }
                }
                let closestX = level0Position.x - CGFloat(levelGroupXOffset * levelGroupIndex)
                let moveToClosest = SKAction.move(to: CGPoint(x: closestX, y: level0Position.y), duration: 0.2)
                moveToClosest.timingMode = .easeOut
                levelGroupNode.run(moveToClosest)
            }
        default:
            break
        }
        recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view!)
    }

    override func tap(_ recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPoint(fromView: recognizer.location(in: self.view))
        let positionInLevels = self.convert(positionInScene, to: levelGroupNode)
        for levelNode in buttonNodes {
            if levelNode.contains(positionInLevels){
                levelNode.run(actionPress)
                if let levelNumber = levelNode.userData?["level"] as! Int? {
                    if userDelegate?.levelStatus(levelNumber) != .inaccessible {
                        userDelegate?.updateLevel(levelNumber)
                        let gameScene = GameSKScene(levelNumber: levelNumber)
                        gameScene.gameSceneDelegate = previousGameScene?.gameSceneDelegate
                        self.view?.presentScene(gameScene, transition: transitionDown)
                    }
                } else {
                    self.view?.presentScene(previousGameScene!, transition: transitionDown)
                }
            }
        }
        if soundNode.contains(positionInScene) {
            soundNode.run(actionPress)
            soundNode.toggle(userDelegate!.toggleSound())
        }
        
        if tip0Node.contains(positionInScene) {
            tip0Node.run(actionPress)
            if tip0Node.product != nil {
                userDelegate?.leaveTip(tip0Node.product!)
            }
        }
        if tip1Node.contains(positionInScene) {
            tip1Node.run(actionPress)
            if tip1Node.product != nil {
                userDelegate?.leaveTip(tip1Node.product!)
            }
        }
        if tip2Node.contains(positionInScene) {
            tip2Node.run(actionPress)
            if tip2Node.product != nil {
                userDelegate?.leaveTip(tip2Node.product!)
            }
        }
    }
}
