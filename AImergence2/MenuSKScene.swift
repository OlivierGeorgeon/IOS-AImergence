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
    func currentlevel() -> Int
    func updateLevel(level: Int)
    func levelStatus(level: Int) -> Int
    func leaveTip(product: SKProduct)
    func getProducts() -> [SKProduct]
}

class MenuSKScene: PositionedSKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "niveaux.png")
    let label0Node = SKLabelNode()
    var tip0Node: TipSKNode?
    var tip1Node: TipSKNode?
    var tip2Node: TipSKNode?
    
    var shortTipInvit = ""
    var longTipInvit = ""
    
    let level0Position      = CGPoint(x: 60, y: 550)
    let levelXOffset        = CGVector( dx: 60, dy: 0)
    let levelYOffset        = CGVector( dx:  0, dy: -80)

    let gameModel = GameModel2()

    weak var userDelegate: MenuSceneDelegate?
    var buttonNodes = [SKNode]()
    var previousGameScene:GameSKScene?

    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */

        backgroundColor = UIColor.whiteColor()
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        addChild(backgroundNode)

        buttonNodes = createButtons(view.frame.size)
        
        label0Node.fontName = PositionedSKScene.bodyFont.fontName
        label0Node.fontSize = PositionedSKScene.titleFont.pointSize
        label0Node.fontColor = UIColor.darkGrayColor()
        label0Node.verticalAlignmentMode = .Center
        addChild(label0Node)

        let products = userDelegate!.getProducts()
        
        if products.count > 0 {
            shortTipInvit =  products[0].localizedDescription
            tip0Node = TipSKNode(product: products[0], size: CGSize(width: 70, height: 70))
            addChild(tip0Node!)
            if products.count > 1 {
                longTipInvit =  products[1].localizedDescription
                tip1Node = TipSKNode(product: products[1], size: CGSize(width: 80, height: 80))
                addChild(tip1Node!)
                if products.count > 2 {
                    tip2Node = TipSKNode(product: products[2], size: CGSize(width: 80, height: 80))
                    addChild(tip2Node!)
                }
            }
        } 
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuSKScene.tap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer);
        
        super.didMoveToView(view)
    }
    
    override func positionInFrame(frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            backgroundNode.position = CGPoint(x: 300, y: 300)
        } else {
            backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
        
        if frameSize.width >= 480 { // portrait - iPhone 4s portrait width
            label0Node.text = longTipInvit
            tip0Node?.position = CGPoint(x: size.width / 2 - 170, y: 130)
            tip1Node?.position = CGPoint(x: size.width / 2, y: 70)
            tip2Node?.position = CGPoint(x: size.width / 2 + 170, y: 105)
        } else {
            label0Node.text = shortTipInvit
            tip0Node?.position = CGPoint(x: size.width / 2 - 100, y: 130)
            tip1Node?.position = CGPoint(x: size.width / 2 - 10, y: 70)
            tip2Node?.position = CGPoint(x: size.width / 2 + 100, y: 105)
        }
        label0Node.position = CGPoint(x: self.size.width / 2, y: 210)
        while label0Node.frame.size.width >= self.size.width {
            label0Node.fontSize -= 1.0
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
            addChild(levelNode)
            
            var backgroundNode = SKShapeNode()
            switch userDelegate!.levelStatus(i) {
            case 1:
                backgroundNode = SKShapeNode(rect: CGRect(x: -25, y: -25, width: 50, height: 50), cornerRadius: 15)
            case 2:
                backgroundNode = SKShapeNode(rect: CGRect(x: -25, y: -25, width: 50, height: 50))
            default:
                backgroundNode = SKShapeNode(path: UIBezierPath(ovalInRect: CGRect(x: -25, y: -25, width: 50, height: 50)).CGPath)
            }
            
            if i == userDelegate?.currentlevel() {
                //backgroundNode.fillColor = UIColor.blackColor()
                backgroundNode.fillColor = UIColor(red: 114 / 256, green: 114 / 256, blue: 171 / 256, alpha: 1)
            } else  {
                //backgroundNode.fillColor = UIColor.lightGrayColor()
                backgroundNode.fillColor = UIColor(red: 150 / 256, green: 100 / 256, blue: 150 / 256, alpha: 1)
                //backgroundNode.fillColor = UIColor(red: 204 / 256, green: 153 / 256, blue: 04 / 256, alpha: 1)
            }
            backgroundNode.lineWidth = 0
            levelNode.addChild(backgroundNode)
        }
        return buttonNodes
    }
    
    func createLabelNode(text: String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = PositionedSKScene.titleFont.fontName
        labelNode.fontSize = PositionedSKScene.titleFont.pointSize
        labelNode.fontColor = UIColor.whiteColor()
        labelNode.verticalAlignmentMode = .Center
        return labelNode
    }

    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        for levelNode in buttonNodes {
            if levelNode.containsPoint(positionInScene){
                levelNode.runAction(actionPress)
                if let ln = levelNode.userData?["level"] as! Int? {
                    if userDelegate?.levelStatus(ln) > 0 {
                        userDelegate?.updateLevel(ln)
                        let gameModel = GameModel.createGameModel(ln)
                        let gameScene = GameSKScene(gameModel: gameModel)
                        gameScene.gameSceneDelegate = previousGameScene?.gameSceneDelegate
                        self.view?.presentScene(gameScene, transition: PositionedSKScene.transitionDown)
                    }
                } else {
                    self.view?.presentScene(previousGameScene!, transition: PositionedSKScene.transitionDown)
                }
            }
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