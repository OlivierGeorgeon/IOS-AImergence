//
//  GameScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate
{
    func playExperience(experience: Experience)
    func unlockLevel()
    func isUnlockedLevel() -> Bool
    func isInstructionUnderstood() -> Bool
    func isImagineUnderstood() -> Bool
    func showInstructionWindow()
    func showImagineWindow()
    func showLevelWindow()
}

class GameSKScene: PositionedSKScene {
    
    let gameModel:GameModel2
    let level:Level0
    
    let actionMoveButton    = SKAction.moveBy(CGVector(dx:0, dy: 60), duration: 0.2)
    let actionScaleButton   = SKAction.scaleTo(1.0, duration: 0.2)
    let actionClearButton   = SKAction.scaleTo(0.0, duration: 0.1)
    
    var gameSceneDelegate: GameSceneDelegate!
    var experimentNodes = Set<ExperimentSKNode>()
    var experienceNodes = Set<ExperienceSKNode>()
    var clock:Int = 0
    var scoreLabel:SKLabelNode
    var scoreBackground:SKShapeNode
    var shapePopupNode:SKNode?
    var shapeNodes = Array<SKShapeNode>()
    var colorPopupNode:SKNode?
    var colorNodes = Array<SKShapeNode>()
    var editNode: ReshapableSKNode?
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            if score >= level.winScore {
                scoreBackground.fillColor = UIColor.greenColor()
                gameSceneDelegate.unlockLevel()
                if buttonIndex != 1 && !gameSceneDelegate.isImagineUnderstood() {
                    buttonIndex = 1
                    showButton()
                }
            } else {
                scoreBackground.fillColor = UIColor.whiteColor()
            }
        }
    }
    
    var robotHappyFrames: [SKTexture]!
    var robotSadFrames: [SKTexture]!
    var robotBlinkFrames: [SKTexture]!
    
    var buttonIndex = 0
    var buttonTextures = [SKTexture(imageNamed: "instructions"), SKTexture(imageNamed: "imagine"), SKTexture(imageNamed: "levels")]
    
    init(gameModel: GameModel2)
    {
        self.level = gameModel.level
        self.gameModel = gameModel
        scoreLabel = gameModel.createScoreLabel()
        scoreBackground = gameModel.createScoreBackground()
        super.init(size: PositionedSKScene.portraitSize)
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        self.addChild(cameraNode!)
        cameraNode!.addChild(cameraRelativeOriginNode)        
        layoutScene()
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.level = Level0()
        self.gameModel = GameModel2()
        scoreLabel = gameModel.createScoreLabel()
        scoreBackground = gameModel.createScoreBackground()
        super.init(coder: aDecoder)
        layoutScene()
    }
    
    func layoutScene()
    {
        anchorPoint = CGPointZero
        scaleMode = .AspectFill
        name = "gameScene"
        
        backgroundColor = gameModel.backgroundColor
        
        self.addChild(scoreBackground)
        scoreBackground.addChild(scoreLabel)

        shapePopupNode = gameModel.createShapePopup()
        for i in 0..<ReshapableSKNode.paths.count {
            let shapeNode = SKShapeNode(path: ReshapableSKNode.paths[i](CGRect(x: -40, y: -40, width: 80, height: 80)).CGPath)
            shapeNode.lineWidth = 3
            shapeNode.strokeColor = UIColor.grayColor()
            shapeNode.fillColor = UIColor.whiteColor()
            shapeNode.position = CGPoint(x: i * 100 - 100 , y: 0)
            shapePopupNode!.addChild(shapeNode)
            shapeNodes.append(shapeNode)
        }
        
        colorPopupNode = gameModel.createColorPopup()
        for i in 0..<ExperienceSKNode.colors.count {
            let colorNode = SKShapeNode(rect: gameModel.colorNodeRect)
            colorNode.fillColor = ExperienceSKNode.colors[i]
            colorNode.strokeColor = UIColor.grayColor()
            colorNode.lineWidth = 1
            colorNode.position = CGPoint(x:0, y: i * 80 - 160)
            colorPopupNode?.addChild(colorNode)
            colorNodes.append(colorNode)
        }
        
        for i in 0...(level.experiments.count - 1) {
            let experimentNode = ExperimentSKNode(experiment: level.experiments[i], gameModel: gameModel)
            experimentNode.position = gameModel.experimentPositions[i]
            addChild(experimentNode)
            experimentNodes.insert(experimentNode)
        }
        robotNode = gameModel.createRobotNode()
        cameraRelativeOriginNode.addChild(robotNode!)
        backgroundNode = gameModel.createBackroundNode()
        cameraRelativeOriginNode.addChild(backgroundNode!)
        buttonNode = SKSpriteNode(imageNamed: "instructions")
        buttonNode!.setScale(0.0)
        cameraRelativeOriginNode.addChild(buttonNode!)
        
        robotHappyFrames = loadFrames("happy", imageNumber: 20, by: 4)
        robotSadFrames = loadFrames("sad", imageNumber: 20, by: 4)
        robotBlinkFrames = loadFrames("blink", imageNumber: 9, by: 3)
    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        super.didMoveToView(view)

        if !gameSceneDelegate.isInstructionUnderstood() {
            buttonIndex = 0
        } else {
            if gameSceneDelegate.isUnlockedLevel() && !gameSceneDelegate.isImagineUnderstood() {
                buttonIndex = 1
            } else {
                buttonIndex = -1
            }
        }
        showButton()

        for recognizer in view.gestureRecognizers ?? [] {
            if recognizer is UITapGestureRecognizer || recognizer is UILongPressGestureRecognizer {
                view.removeGestureRecognizer(recognizer)
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameSKScene.tap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameSKScene.longPress(_:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
        
    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        for experimentNode in experimentNodes {
            if experimentNode.containsPoint(positionInScene){
                play(experimentNode)
            }
        }
        if robotNode!.containsPoint(positionInScene) {
            buttonIndex += 1; if buttonIndex > 2 { buttonIndex = -1 }
            showButton()
        }
        if buttonNode!.containsPoint(positionInScene) {
            switch buttonIndex {
            case 0:
                gameSceneDelegate.showInstructionWindow()
            case 1:
                gameSceneDelegate.showImagineWindow()
            case 2:
                gameSceneDelegate.showLevelWindow()
            default:
                break
            }
        }
    }
    
    func showButton() {
        if buttonIndex == -1 {
            //buttonNode!.runAction(actionClearButton)
            buttonNode?.texture = nil
        } else {
            buttonNode!.setScale(0)
            buttonNode!.position.y -= 60
            buttonNode!.runAction(SKAction.group([actionScaleButton, actionMoveButton]))
            buttonNode?.texture = buttonTextures[buttonIndex]
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
                    cameraRelativeOriginNode.addChild(colorPopupNode!)
                }
            }
        case .Ended:
            for i in 0..<ReshapableSKNode.paths.count {
                if shapeNodes[i].containsPoint(positionInShapePopup!) {
                    if let experimentNode = editNode as? ExperimentSKNode {
                        experimentNode.experiment.shapeIndex = i
                        experimentNode.reshape()
                        for node in experienceNodes {
                            if node.experience.experimentNumber == experimentNode.experiment.number {
                                node.reshape()
                            }
                        }
                    }
                }
            }
            shapePopupNode?.removeFromParent()
            for i in 0..<ExperienceSKNode.colors.count {
                if colorNodes[i].containsPoint(positionInColorPopup!) {
                    if let experienceNode = editNode as? ExperienceSKNode {
                        experienceNode.experience.colorIndex = i
                        for node in experienceNodes {
                            node.refill()
                        }
                    }
                }
            }
            colorPopupNode?.removeFromParent()
            editNode = nil
        default:
            break
        }
    }
    
    func play(experimentNode: ExperimentSKNode) {
        
        clock += 1
        
        let experiment = experimentNode.experiment
        
        let(experience, score) = level.play(experiment)
        self.score = score

        switch experience.valence {
        case let x where x > 0 :
            animRobot(robotHappyFrames)
        case let x where x < 0:
            animRobot(robotSadFrames)
        default:
            animRobot(robotBlinkFrames)
        }
        
        gameSceneDelegate.playExperience(experience)
        
        for node in experienceNodes {
            if node.isObsolete(clock) {
                node.removeFromParent()
                experienceNodes.remove(node)
            } else {
                node.runAction(gameModel.actionMoveTrace)
            }
        }
        
        let experienceNode = ExperienceSKNode(experience: experience, stepOfCreation: clock, gameModel: gameModel)
        experienceNode.position = experimentNode.position 
        addChild(experienceNode)
        experienceNodes.insert(experienceNode)
        
        let actionIntroduce = SKAction.moveBy(gameModel.moveByVect(experimentNode.position), duration: 0.3)

        experienceNode.runAction(gameModel.actionScale)
        experienceNode.runAction(actionIntroduce, completion: {experienceNode.addValenceNode()})
    }
    
    func animRobot(texture: [SKTexture]) {
        robotNode!.runAction(
            SKAction.animateWithTextures(texture, timePerFrame: 0.05, resize: false, restore: false))
    }
    
    func loadFrames(imageName: String, imageNumber: Int, by: Int) -> [SKTexture] {
        var frames = [SKTexture]()
        
        for i in 1.stride(to: imageNumber, by: by) {
        //for var i=1; i<=imageNumber; i = i + 3 {
            let textureName = imageName + "\(i)"
            //frames.append(robotAtlas.textureNamed(textureName))
            frames.append(SKTexture(imageNamed: textureName))
        }
        for i in imageNumber.stride(to: 0, by: -by) {
        //for var i = imageNumber - 1; i > 0; i = i - 3 {
            let textureName = imageName + "\(i)"
            //frames.append(robotAtlas.textureNamed(textureName))
            frames.append(SKTexture(imageNamed: textureName))
        }
        frames.append(SKTexture(imageNamed: imageName + "1"))
        return frames
    }
}

