//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

protocol MenuSceneDelegate: class
{
    func currentlevel() -> Int
    func updateLevel(level: Int)
    func levelStatus(level: Int) -> Int
}

class MenuSKScene: PositionedSKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "niveaux.png")
    let instructionNode = SKLabelNode(text: NSLocalizedString("Swipe", comment: "Swipe horizontally to change level."))
    
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

        instructionNode.fontName = PositionedSKScene.bodyFont.fontName
        instructionNode.fontSize = PositionedSKScene.bodyFont.pointSize
        instructionNode.fontColor = UIColor.blackColor()
        instructionNode.verticalAlignmentMode = .Center
        addChild(instructionNode)
        
        buttonNodes = createButtons(view.frame.size)
        
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
        instructionNode.position = CGPoint(x: self.size.width / 2, y: 50)
        instructionNode.fontSize = PositionedSKScene.titleFont.pointSize
        while instructionNode.frame.size.width >= self.size.width {
            instructionNode.fontSize-=1.0
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
    }
}