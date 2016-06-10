//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

protocol MenuSceneDelegate
{
    func currentlevel() -> Int
    func updateLevel(level: Int)
    func levelStatus(level: Int) -> Int
}

class MenuSKScene: PositionedSKScene {
    
    let cancelString = NSLocalizedString("Cancel", comment: "The Cancel button in the level-selection window.")
    let swipeString = NSLocalizedString("Swipe", comment: "Swipe horizontally to change level.")
    
    let level0Position      = CGPoint(x: 60, y: 540)
    let levelXOffset        = CGVector( dx: 60, dy: 0)
    let levelYOffset        = CGVector( dx:  0, dy: -80)

    let gameModel = GameModel2()

    var userDelegate: MenuSceneDelegate?
    var buttonNodes = [SKNode]()
    var previousGameScene:GameSKScene?

    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        positionInFrame(view.frame.size)
        backgroundColor = UIColor.whiteColor()

        let cancelNode = createLabelNode(cancelString)
        cancelNode.name = "Cancel"
        cancelNode.position = CGPoint(x: 187, y: 150)
        buttonNodes.append(cancelNode)
        addChild(cancelNode)
        
        let instructionNode = SKLabelNode(text: swipeString)
        instructionNode.fontName = PositionedSKScene.bodyFont.fontName
        instructionNode.fontSize = PositionedSKScene.bodyFont.pointSize
        instructionNode.fontColor = UIColor.blackColor()
        instructionNode.verticalAlignmentMode = .Center
        instructionNode.position = CGPoint(x: 187, y: 50)
        while instructionNode.frame.size.width >= 375 {
            instructionNode.fontSize-=1.0
        }
        addChild(instructionNode)
        
        let cancelBackgroundNode = SKShapeNode(rect: CGRect(x: -100, y: -20, width: 200, height: 40), cornerRadius: 20)
        cancelBackgroundNode.fillColor = UIColor.lightGrayColor()
        cancelBackgroundNode.lineWidth = 0
        cancelNode.addChild(cancelBackgroundNode)
        
        for i in 0...GameViewController.maxLevelNumber {
            let levelNode = createLabelNode("\(i)")
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
            
            if i == userDelegate?.currentlevel() { backgroundNode.fillColor = UIColor.blackColor() }
            else { backgroundNode.fillColor = UIColor.lightGrayColor() }
            backgroundNode.lineWidth = 0
            levelNode.addChild(backgroundNode)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuSKScene.tap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer);
        let robotNode = gameModel.createRobotNode()
        robotNode.position = CGPoint(x: 300, y: 300)
        addChild(robotNode)
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
                if let ln = levelNode.userData?["level"] as! Int? {
                    if userDelegate?.levelStatus(ln) > 0 {
                        userDelegate?.updateLevel(ln)
                        let gameModel = GameModel.createGameModel(ln)
                        let gameScene = GameSKScene(gameModel: gameModel)
                        gameScene.gameSceneDelegate = previousGameScene?.gameSceneDelegate
                        self.view?.presentScene(gameScene, transition: PositionedSKScene.transitionUp)
                    }
                } else {
                    self.view?.presentScene(previousGameScene!, transition: PositionedSKScene.transitionUp)
                }
            }
        }
    }
}