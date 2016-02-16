//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

protocol HomeSceneDelegate
{
    func updateLevel(level: Int)
}

class HomeScene: PositionedSKScene {
    
    let cancelString = NSLocalizedString("Cancel", comment: "The Cancel button in the level-selection window.")

    var userDelegate:HomeSceneDelegate?
    var buttonNodes = [SKNode]()
    var previousGameScene:GameScene?

    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        positionInFrame(view.frame.size)
        backgroundColor = UIColor.whiteColor()

        let homeStruct = HomeStruct()

        let cancelNode = homeStruct.createLabelNode(cancelString)
        cancelNode.name = "Cancel"
        cancelNode.position = homeStruct.cancelPosition
        buttonNodes.append(cancelNode)
        addChild(cancelNode)
        
        let cancelBackgroundNode = homeStruct.createBackgroundNode()
        cancelNode.addChild(cancelBackgroundNode)
        
        for i in 0...PositionedSKScene.maxLevelNumber {
            let levelNode = homeStruct.createLabelNode("\(i)")
            levelNode.userData = ["level": i]
            levelNode.position = homeStruct.level0Position + (i % 5) * homeStruct.levelXOffset + (i / 5) * homeStruct.levelYOffset
            buttonNodes.append(levelNode)
            addChild(levelNode)
            
            let backgroundNode = homeStruct.createLevelBackgroundNode()
            levelNode.addChild(backgroundNode)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGestureRecognizer);
    }

    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        for levelNode in buttonNodes {
            if levelNode.containsPoint(positionInScene){
                if let ln = levelNode.userData?["level"] as! Int? {
                    userDelegate?.updateLevel(ln)
                    let gameScene = GameStruct.createGameScene(ln)
                    gameScene.gameSceneDelegate = previousGameScene?.gameSceneDelegate
                    self.view?.presentScene(gameScene, transition: PositionedSKScene.transitionUp)
                } else {
                    self.view?.presentScene(previousGameScene!, transition: PositionedSKScene.transitionUp)
                }
            }
        }
    }
}