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

class HomeScene: SKScene {
    
    let homeStruct = HomeStruct()
    let cancelString = NSLocalizedString("Cancel", comment: "The Cancel button in the level-selection window.")

    
    var userDelegate:HomeSceneDelegate?
    
    var buttonNodes = [SKNode]()
    
    var cancelScene:GameScene?

    override init() {
        super.init(size: homeStruct.portraitSceneSize)
        layoutScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutScene()
    }

    func layoutScene()
    {
        backgroundColor = homeStruct.backgroundColor
        let cancelNode = homeStruct.createLabelNode(cancelString)
        cancelNode.name = "Cancel"
        cancelNode.position = homeStruct.cancelPosition
        buttonNodes.append(cancelNode)
        addChild(cancelNode)

        let cancelBackgroundNode = homeStruct.createBackgroundNode()
        cancelNode.addChild(cancelBackgroundNode)
        
        for i in 0...HomeStruct.numberOfLevels {
            let levelNode = homeStruct.createLabelNode("\(i)")
            levelNode.userData = ["level": i]
            levelNode.position = homeStruct.level0Position + (i % 5) * homeStruct.levelXOffset + (i / 5) * homeStruct.levelYOffset
            buttonNodes.append(levelNode)
            addChild(levelNode)
            
            let backgroundNode = homeStruct.createLevelBackgroundNode()
            levelNode.addChild(backgroundNode)
        }
    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        
        var size = homeStruct.portraitSceneSize
        if UIDevice.currentDevice().orientation == .LandscapeRight ||
            UIDevice.currentDevice().orientation == .LandscapeLeft {
                size = homeStruct.landscapeSceneSize
        }
        self.size = size

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
                        self.view?.presentScene(gameScene, transition: homeStruct.transitionOut)
                    } else {
                        self.view?.presentScene(cancelScene!, transition: homeStruct.transitionOut)
                    }
                }
            }
    }
}