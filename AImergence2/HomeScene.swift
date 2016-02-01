//
//  HomeScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 13/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    
    let homeStruct = HomeStruct()
    
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
        let cancelNode = homeStruct.createLabelNode("Cancel")
        cancelNode.name = "Cancel"
        cancelNode.position = homeStruct.cancelPosition
        buttonNodes.append(cancelNode)
        addChild(cancelNode)

        let cancelBackgroundNode = homeStruct.createBackgroundNode()
        cancelNode.addChild(cancelBackgroundNode)
        
        var position = homeStruct.level0Position
        for i in 0...homeStruct.numberOfLevels {
            let levelNode = homeStruct.createLabelNode("Level \(i)")
            levelNode.userData = ["level": i]
            levelNode.position = position
            buttonNodes.append(levelNode)
            addChild(levelNode)
            
            let backgroundNode = homeStruct.createBackgroundNode()
            levelNode.addChild(backgroundNode)
            
            position += homeStruct.levelOffsetVector
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
                        let gameScene = GameStruct.createGameScene(ln)
                        self.view?.presentScene(gameScene, transition: homeStruct.transitionOut)
                    } else {
                        self.view?.presentScene(cancelScene!, transition: homeStruct.transitionOut)
                    }
                }
            }
    }
}