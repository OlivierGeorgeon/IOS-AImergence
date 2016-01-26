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

//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        
        //if let positionInScene = touches.first?.locationInNode(self) {
            for levelNode in buttonNodes {
                if levelNode.containsPoint(positionInScene){
                    if let ln = levelNode.userData?["level"] as! Int? {
                        let level:Level0
                        var gameStruct = GameStruct()
                        switch ln {
                        case 0:
                            level = Level0()
                        case 1:
                            level = Level1()
                        case 2:
                            level = Level2()
                        case 3:
                            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
                            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
                            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
                            level = Level3()
                        case 4:
                            let experimentStruct = ExperimentStruct(rect:CGRect(x: -50, y: -50, width: 100, height: 100))
                            let experienceStruct = ExperienceStruct(initialScale:CGFloat(100)/40)
                            gameStruct = GameStruct(experiment:experimentStruct, experience:experienceStruct,
                                experimentPositions: [CGPoint(x: 80, y: 100), CGPoint(x: 295, y: 100), CGPoint(x: 187, y: 100)])
                            level = Level4()
                        default:
                            level = Level0()
                        }
                        let gameScene = GameScene(level: level, gameStruct: gameStruct)
                        self.view?.presentScene(gameScene, transition: homeStruct.transitionOut)
                    } else {
                        self.view?.presentScene(cancelScene!, transition: homeStruct.transitionOut)
                    }
                }
            }
        //}
    }
}