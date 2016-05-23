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
    func isInstructionUnderstood() -> Bool
    func isImagineUnderstood() -> Bool
    func isLevelUnlocked() -> Bool
    func isInterfaceUnlocked(interface: Int) -> Bool
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
    var experimentNodes = [ExperimentSKNode]()
    var experienceNodes = Set<ExperienceSKNode>()
    var clock:Int = 0
    var scoreLabel:SKLabelNode
    var scoreBackground:SKShapeNode
    var shapePopupNode:SKNode!
    var shapeNodes = Array<SKShapeNode>()
    var colorPopupNode:SKNode!
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
    var buttonTextures = [[SKTexture(imageNamed: "instructions-black"), SKTexture(imageNamed: "instructions-color")],
                          [SKTexture(imageNamed: "imagine-black"), SKTexture(imageNamed: "imagine-color")],
                          [SKTexture(imageNamed: "levels-color"), SKTexture(imageNamed: "levels-black")]]
    
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
        shapeNodes = gameModel.createShapeNodes(shapePopupNode)
        
        colorPopupNode = gameModel.createColorPopup()
        colorNodes = gameModel.createColorNodes(colorPopupNode)
        
        experimentNodes = gameModel.createExperimentNodes(self)
        
        robotNode = gameModel.createRobotNode()
        cameraRelativeOriginNode.addChild(robotNode!)
        backgroundNode = gameModel.createBackroundNode()
        cameraRelativeOriginNode.addChild(backgroundNode!)
        buttonNode = SKSpriteNode(imageNamed: "instructions")
        buttonNode!.setScale(0.0)
        cameraRelativeOriginNode.addChild(buttonNode!)
        
        robotHappyFrames = loadFrames("happy", imageNumber: 6, by: 1)
        robotSadFrames = loadFrames("sad", imageNumber: 7, by: 1)
        robotBlinkFrames = loadFrames("blink", imageNumber: 9, by: 3)
    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        super.didMoveToView(view)

        if !gameSceneDelegate.isInstructionUnderstood() {
            buttonIndex = 0
        } else {
            if gameSceneDelegate.isLevelUnlocked() && !gameSceneDelegate.isImagineUnderstood() {
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
        let positionInScreen = cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: self)
        for experimentNode in experimentNodes {
            if experimentNode.containsPoint(positionInScene){
                play(experimentNode)
            }
        }
        if robotNode!.containsPoint(positionInScreen) {
            buttonIndex += 1; if buttonIndex > 2 { buttonIndex = -1 }
            showButton()
        }
        if buttonNode!.containsPoint(positionInScreen) {
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
            let textureIndex =  gameSceneDelegate.isInterfaceUnlocked(buttonIndex) ? 0 : 1
            buttonNode?.texture = buttonTextures[buttonIndex][textureIndex]
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
            for i in 0..<shapeNodes.count {
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
            for i in 0..<colorNodes.count {
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

