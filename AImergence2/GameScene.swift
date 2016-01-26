//
//  GameScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameStruct:GameStruct
    let level:Level0

    var experimentNodes = Set<ExperimentNode>()
    var experienceNodes = Set<ExperienceNode>()

    var clock:Int = 0
    var scoreLabel:SKLabelNode
    var scoreBackground:SKShapeNode
    var homeNode:SKNode?
    
    var shapePopupNode:SKNode?
    var shapeNodes = Array<SKShapeNode>()

    var colorPopupNode:SKNode?
    var colorNodes = Array<SKShapeNode>()
    
    var helpNode:SKNode?

    var editNode: ReshapableNode?
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            if score >= level.winScore {
                scoreBackground.fillColor = UIColor.greenColor()
            } else {
                scoreBackground.fillColor = UIColor.grayColor()
            }
        }
    }
    
    init(level: Level0, gameStruct sceneStruct: GameStruct)
    {
        self.level = level
        self.gameStruct = sceneStruct
        scoreLabel = sceneStruct.createScoreLabel()
        scoreBackground = sceneStruct.createScoreBackground()
        homeNode = sceneStruct.createHomeNode()
        super.init(size: sceneStruct.portraitSceneSize)
        layoutScene()
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.level = Level0()
        self.gameStruct = GameStruct()
        scoreLabel = gameStruct.createScoreLabel()
        scoreBackground = gameStruct.createScoreBackground()
        super.init(coder: aDecoder)
        layoutScene()
    }
    
    func layoutScene()
    {
        anchorPoint = CGPointZero
        scaleMode = .AspectFill
        name = "gameScene"
        
        backgroundColor = gameStruct.backgroundColor
        let homeNode = gameStruct.createHomeNode()
        let homeLabel = SKLabelNode(text: "Level \(level.number)")
        homeLabel.fontName = gameStruct.bodyFont.fontName
        homeLabel.fontSize = gameStruct.bodyFont.pointSize
        homeLabel.fontColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0) //UIColor.blueColor()
        homeLabel.verticalAlignmentMode = .Baseline
        homeLabel.position = CGPoint(x: -50, y: -10)
        homeLabel.zPosition = 1
        homeNode.addChild(homeLabel)
        self.addChild(homeNode)
        
        self.addChild(scoreBackground)
        scoreBackground.addChild(scoreLabel)

        shapePopupNode = gameStruct.createShapePopup()
        for i in 0..<ReshapableNode.paths.count {
            let shapeNode = SKShapeNode(path: ReshapableNode.paths[i](CGRect(x: -40, y: -40, width: 80, height: 80)))
            shapeNode.lineWidth = 3
            shapeNode.strokeColor = UIColor.grayColor()
            shapeNode.fillColor = UIColor.whiteColor()
            shapeNode.position = CGPoint(x: i * 100 - 100 , y: 0)
            shapePopupNode!.addChild(shapeNode)
            shapeNodes.append(shapeNode)
        }
        
        colorPopupNode = gameStruct.createColorPopup()
        for i in 0..<ExperienceNode.colors.count {
            let colorNode = SKShapeNode(rect: gameStruct.colorNodeRect)
            colorNode.fillColor = ExperienceNode.colors[i]
            colorNode.strokeColor = UIColor.grayColor()
            colorNode.lineWidth = 1
            colorNode.position = CGPoint(x:0, y: i * 50 - 100)
            colorPopupNode?.addChild(colorNode)
            colorNodes.append(colorNode)
        }
        
        helpNode = gameStruct.createHelpNode()
        self.addChild(helpNode!)

        for i in 0...(level.experiments.count - 1) {
            let experimentNode = ExperimentNode(experiment: level.experiments[i], experimentStruct: gameStruct.experiment)
            experimentNode.position = gameStruct.experimentPositions[i]
            addChild(experimentNode)
            experimentNodes.insert(experimentNode)
        }        
        
    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        
        var size = gameStruct.portraitSceneSize
        if UIDevice.currentDevice().orientation == .LandscapeRight ||
            UIDevice.currentDevice().orientation == .LandscapeLeft {
            size = gameStruct.landscapeSceneSize
        }
        self.size = size

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGestureRecognizer);
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        view.addGestureRecognizer(longPressGestureRecognizer);
    }
    
    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        for experimentNode in experimentNodes {
            if experimentNode.containsPoint(positionInScene){
                play(experimentNode)
            }
        }
        if homeNode!.containsPoint(positionInScene) {
            let homeScene = HomeScene()
            homeScene.cancelScene = self
            self.view?.presentScene(homeScene, transition: gameStruct.transitionOut)
        }
    }
    
    func longPress(recognizer: UILongPressGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInShapePopup = shapePopupNode?.convertPoint(positionInScene, fromNode: self)
        let positionInColorPopup = colorPopupNode?.convertPoint(positionInScene, fromNode: self)

        switch recognizer.state {
        case .Began:
            for experimentNode in experimentNodes {
                if experimentNode.containsPoint(positionInScene) {
                    editNode = experimentNode
                    addChild(shapePopupNode!)
                }
            }
            for experienceNode in experienceNodes {
                if experienceNode.containsPoint(positionInScene) {
                    editNode = experienceNode
                    addChild(colorPopupNode!)
                }
                
            }
        case .Ended:
            for i in 0..<ReshapableNode.paths.count {
                if shapeNodes[i].containsPoint(positionInShapePopup!) {
                    if let experimentNode = editNode as? ExperimentNode {
                        experimentNode.experiment.shapeIndex = i
                        experimentNode.runAction(ReshapableNode.actionReshape)
                        for node in experienceNodes {
                            if node.experience.experimentNumber == experimentNode.experiment.number {
                                node.runAction(ReshapableNode.actionReshape)
                            }
                        }
                    }
                }
            }
            shapePopupNode?.removeFromParent()
            for i in 0..<ExperienceNode.colors.count {
                if colorNodes[i].containsPoint(positionInColorPopup!) {
                    if let experienceNode = editNode as? ExperienceNode {
                        experienceNode.experience.colorIndex = i
                        for node in experienceNodes {
                            node.runAction(ExperienceNode.actionRefill)
                        }
                    }
                }
            }
            colorPopupNode?.removeFromParent()
            
        default:
            break
        }
    }
    
    func play(experimentNode: ExperimentNode) {
        
        clock++
        
        let experiment = experimentNode.experiment
        
        let(experience, score) = level.play(experiment)
        self.score = score
        
        for node in experienceNodes {
            if node.isObsolete(clock) {
                node.removeFromParent()
                experienceNodes.remove(node)
            } else {
                node.runAction(gameStruct.actionMoveTrace)
            }
        }
        
        let experienceNode = ExperienceNode(experience: experience, stepOfCreation: clock, experienceStruct: gameStruct.experience)
        experienceNode.position = experimentNode.position 
        addChild(experienceNode)
        experienceNodes.insert(experienceNode)
        
        let actionIntroduce = SKAction.moveBy(gameStruct.moveByVect(experimentNode.position), duration: 0.3)

        experienceNode.runAction(gameStruct.actionScale)
        experienceNode.runAction(actionIntroduce, completion: {experienceNode.addValenceNode()})
    }
    
}

