//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit
import StoreKit

protocol MenuSceneDelegate: class
{
    func currentLevel() -> Int
    func updateLevel(level: Int)
    func levelStatus(level: Int) -> Int
    func leaveTip(product: SKProduct)
    func getProducts() -> [SKProduct]
    func isPaidTip() -> Bool
    func isSoundEnabled() -> Bool
    func toggleSound() -> Bool
}

class MenuSKScene: PositionedSKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "niveaux.png")
    let originNode = SKNode()
    let tipInviteNode = SKLabelNode()
    let tutorNode = TutorSKNode()
    let soundNode = SoundSKNode()
    let level0Position = CGPoint(x: 120, y: 1100)
    let levelXOffset = CGVector( dx: 120, dy: 0)
    let levelYOffset = CGVector( dx:  0, dy: -160)
    let thankYou = NSLocalizedString("Thank you!", comment: "In the level window when the user has paid a tip.")

    weak var userDelegate: MenuSceneDelegate?

    var tip0Node: TipSKNode?
    var tip1Node: TipSKNode?
    var tip2Node: TipSKNode?
    var shortTipInvit = ""
    var longTipInvit = ""
    var buttonNodes = [SKNode]()
    var previousGameScene:GameSKScene?

    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */

        addChild(originNode)
        tutorNode.level = userDelegate!.currentLevel()
        if userDelegate!.currentLevel() == 3 && userDelegate!.isSoundEnabled() {
            tutorNode.tip(14, parentNode: soundNode)
        }
        backgroundColor = UIColor.whiteColor()
        backgroundNode.size = CGSize(width: 1334, height: 1334)
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        originNode.addChild(backgroundNode)
        
        soundNode.toggle(userDelegate!.isSoundEnabled())
        addChild(soundNode)

        buttonNodes = createButtons(view.frame.size)
        
        tipInviteNode.fontName = bodyFont.fontName
        tipInviteNode.fontColor = UIColor.darkGrayColor()
        tipInviteNode.verticalAlignmentMode = .Center
        originNode.addChild(tipInviteNode)

        let products = userDelegate!.getProducts()
        
        if products.count > 0 {
            shortTipInvit =  products[0].localizedDescription
            tip0Node = TipSKNode(product: products[0], size: CGSize(width: 140, height: 140))
            originNode.addChild(tip0Node!)
            if products.count > 1 {
                longTipInvit =  products[1].localizedDescription
                tip1Node = TipSKNode(product: products[1], size: CGSize(width: 160, height: 160))
                originNode.addChild(tip1Node!)
                if products.count > 2 {
                    tip2Node = TipSKNode(product: products[2], size: CGSize(width: 160, height: 160))
                    originNode.addChild(tip2Node!)
                }
            }
        }
        
        if userDelegate!.isPaidTip() {
            shortTipInvit = thankYou
            longTipInvit = shortTipInvit
        }
        
        super.didMoveToView(view)
    }
    
    override func positionInFrame(frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            backgroundNode.position = CGPoint(x: 600, y: 600)
            tipInviteNode.text = shortTipInvit
            tip0Node?.position = CGPoint(x: size.width / 2 - 200, y: 260)
            tip1Node?.position = CGPoint(x: size.width / 2 - 20, y: 140)
            tip2Node?.position = CGPoint(x: size.width / 2 + 200, y: 210)
        } else {
            backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
            tipInviteNode.text = longTipInvit
            tip0Node?.position = CGPoint(x: size.width / 2 - 340, y: 260)
            tip1Node?.position = CGPoint(x: size.width / 2, y: 140)
            tip2Node?.position = CGPoint(x: size.width / 2 + 340, y: 210)
        }
        
        tipInviteNode.position = CGPoint(x: self.size.width / 2, y: 420)
        tipInviteNode.fontSize = titleFont.pointSize * 2
        while tipInviteNode.frame.size.width >= self.size.width {
            tipInviteNode.fontSize -= 1.0
        }
    }
    
    func createButtons(frameSize: CGSize) -> [SKNode]
    {
        var buttonNodes = [SKNode]()
        for i in 0...GameViewController.maxLevelNumber {
            let levelNode = createLabelNode("\(i)")
            levelNode.fontName = "Noteworthy-Bold"
            levelNode.userData = ["level": i]
            levelNode.position = level0Position + (i % 5) * levelXOffset + (i / 5) * levelYOffset
            buttonNodes.append(levelNode)
            originNode.addChild(levelNode)
            
            var backgroundNode = SKShapeNode()
            switch userDelegate!.levelStatus(i) {
            case 1:
                backgroundNode = SKShapeNode(rect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 30)
            case 2:
                backgroundNode = SKShapeNode(rect: CGRect(x: -50, y: -50, width: 100, height: 100))
            default:
                backgroundNode = SKShapeNode(path: UIBezierPath(ovalInRect: CGRect(x: -50, y: -50, width: 100, height: 100)).CGPath)
            }
            
            if i == userDelegate?.currentLevel() {
                backgroundNode.fillColor = UIColor(red: 114 / 256, green: 114 / 256, blue: 171 / 256, alpha: 1)
            } else  {
                backgroundNode.fillColor = UIColor(red: 150 / 256, green: 100 / 256, blue: 150 / 256, alpha: 1)
            }
            backgroundNode.lineWidth = 0
            levelNode.addChild(backgroundNode)
        }
        return buttonNodes
    }
    
    func createLabelNode(text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = titleFont.fontName
        labelNode.fontSize = titleFont.pointSize * 2
        labelNode.fontColor = UIColor.whiteColor()
        labelNode.verticalAlignmentMode = .Center
        return labelNode
    }

    override func pan(recognizer: UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(self.view!)
        switch recognizer.state {
        case .Changed:
            originNode.position.y -= translation.y * sceneHeight / self.view!.frame.height
        case .Ended:
            if recognizer.velocityInView(self.view!).y > 200 {
                self.view!.presentScene(previousGameScene!, transition: transitionDown)
            } else {
                let moveToOrigin = SKAction.moveTo(CGPointZero, duration: 0.2)
                moveToOrigin.timingMode = .EaseInEaseOut
                originNode.runAction(moveToOrigin)
            }
        default:
            break
        }
        recognizer.setTranslation(CGPoint(x: 0,y: 0), inView: self.view!)
    }

    override func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        for levelNode in buttonNodes {
            if levelNode.containsPoint(positionInScene){
                levelNode.runAction(actionPress)
                if let levelNumber = levelNode.userData?["level"] as! Int? {
                    if userDelegate?.levelStatus(levelNumber) > 0 {
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
        if soundNode.containsPoint(positionInScene) {
            soundNode.runAction(actionPress)
            soundNode.toggle(userDelegate!.toggleSound())
            tutorNode.tapSound(tipInviteNode)
        }
        
        if tip0Node != nil {
            if tip0Node!.containsPoint(positionInScene) {
                tip0Node!.runAction(actionPress)
                userDelegate?.leaveTip(tip0Node!.product)
            }
        }
        if tip1Node != nil {
            if tip1Node!.containsPoint(positionInScene) {
                tip1Node!.runAction(actionPress)
                userDelegate?.leaveTip(tip1Node!.product)
            }
        }
        if tip2Node != nil {
            if tip2Node!.containsPoint(positionInScene) {
                tip2Node!.runAction(actionPress)
                userDelegate?.leaveTip(tip2Node!.product)
            }
        }
    }
}