//
//  GameScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate: class
{
    func playExperience(experience: Experience)
    func unlockLevel(score: Int)
    func isInstructionUnderstood() -> Bool
    func isImagineUnderstood() -> Bool
    func isLevelUnlocked() -> Bool
    func isInterfaceUnlocked(interface: Int) -> Bool
    func showInstructionWindow()
    func showImagineWindow()
    func showGameCenter()
    func showLevelWindow()
}

enum BUTTON: Int { case INSTRUCTION, IMAGINE, GAMECENTER, LEVEL, NONE}

class GameSKScene: PositionedSKScene {
    
    let gameModel:GameModel2
    let level:Level0
    
    let backgroundNode = SKSpriteNode(imageNamed: "fond.png")
    let robotNode = SKSpriteNode(imageNamed: "happy1.png")
    let cameraNode = SKCameraNode()
    let cameraRelativeOriginNode = SKNode()
    
    let instructionButtonNode = ButtonSKNode(activatedImageNamed: "instructions-color", disactivatedImageNamed: "instructions-black")
    let imagineButtonNode = ButtonSKNode(activatedImageNamed: "imagine-color", disactivatedImageNamed: "imagine-black")
    let gameCenterButtonNode = ButtonSKNode(activatedImageNamed: "gamecenter-color", disactivatedImageNamed: "gamecenter-black")
    let levelButtonNode = ButtonSKNode(activatedImageNamed: "levels-color", disactivatedImageNamed: "levels-black")
    
    var timer: NSTimer?
    
    var currentButton = BUTTON.NONE
    
    weak var gameSceneDelegate: GameSceneDelegate!
    var experimentNodes = [ExperimentSKNode]()
    var experienceNodes = Set<ExperienceSKNode>()
    var clock:Int = 0
    var scoreLabel:SKLabelNode
    var scoreBackground:SKShapeNode
    var shapePopupNode:SKNode!
    var shapeNodes = Array<SKShapeNode>()
    var shapeNodeIndex = 0
    var colorPopupNode: SKNode?
    var colorNodes = Array<SKShapeNode>()
    var colorNodeIndex = 0
    var editNode: ReshapableSKNode?
    var won = false
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            scoreLabel.removeAllChildren()
            scoreLabel.addChild(gaugeNode(score))
            if score >= level.winScore {
                scoreBackground.fillColor = UIColor.greenColor()
                if !won {
                    gameSceneDelegate.unlockLevel(clock)
                    won = true
                    if imagineButtonNode.active {
                        imagineButtonNode.pulse()
                    }
                }
                if !gameSceneDelegate.isImagineUnderstood() {
                    if currentButton == BUTTON.INSTRUCTION {
                        shiftButton()
                    }
                }
            } else {
                scoreBackground.fillColor = UIColor.whiteColor()
            }
        }
    }
    
    var robotHappyFrames: [SKTexture]!
    var robotSadFrames: [SKTexture]!
    var robotBlinkFrames: [SKTexture]!
    
    init(gameModel: GameModel2)
    {
        self.level = gameModel.level
        self.gameModel = gameModel
        scoreLabel = gameModel.createScoreLabel()
        scoreBackground = gameModel.createScoreBackground()
        super.init(size:CGSize(width: 0 , height: 0))
        self.camera = cameraNode
        self.addChild(cameraNode)
        cameraNode.addChild(cameraRelativeOriginNode)
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
        let actionRight = SKAction.moveBy(CGVector(dx: 20, dy: 0), duration: 0.5)
        let actionLeft = SKAction.moveBy(CGVector(dx: -20, dy: 0), duration: 0.5)
        levelButtonNode.actionPulse(SKAction.repeatActionForever(SKAction.sequence([actionRight, actionLeft])))
        
        self.addChild(scoreBackground)
        scoreBackground.addChild(scoreLabel)
        scoreLabel.addChild(gaugeNode(0))
        
        shapePopupNode = gameModel.createShapePopup()
        shapeNodes = gameModel.createShapeNodes(shapePopupNode)
        
        experimentNodes = gameModel.createExperimentNodes(self)
        
        robotNode.size = CGSize(width: 100, height: 100)
        robotNode.position = CGPoint(x: 120, y: 180)
        robotNode.zPosition = 1
        cameraRelativeOriginNode.addChild(robotNode)
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        cameraRelativeOriginNode.addChild(backgroundNode)
        robotNode.addChild(instructionButtonNode)
        robotNode.addChild(imagineButtonNode)
        robotNode.addChild(gameCenterButtonNode)
        robotNode.addChild(levelButtonNode)
        
        robotHappyFrames = loadFrames("happy", imageNumber: 6, by: 1)
        robotSadFrames = loadFrames("sad", imageNumber: 7, by: 1)
        robotBlinkFrames = loadFrames("blink", imageNumber: 9, by: 3)
    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        super.didMoveToView(view)

        // The delegate is ready in didMoveToView
        if !gameSceneDelegate.isInstructionUnderstood() {
            imagineButtonNode.disappear()
            gameCenterButtonNode.disappear()
            levelButtonNode.disappear()
            currentButton = BUTTON.INSTRUCTION
            instructionButtonNode.pulse()
            instructionButtonNode.appear()
        } else if !gameSceneDelegate.isImagineUnderstood() {
            imagineButtonNode.disappear()
            gameCenterButtonNode.disappear()
            levelButtonNode.disappear()
            currentButton = BUTTON.IMAGINE
            imagineButtonNode.pulse()
            imagineButtonNode.appear()
        }
        if gameSceneDelegate.isInstructionUnderstood() {
            instructionButtonNode.disactivate()
        }
        if gameSceneDelegate.isImagineUnderstood() {
            imagineButtonNode.disactivate()
        }
        if gameSceneDelegate.isInterfaceUnlocked(2) {
            gameCenterButtonNode.disactivate()
            levelButtonNode.disactivate()
        }
        
        for recognizer in view.gestureRecognizers ?? [] {
            if recognizer is UITapGestureRecognizer || recognizer is UILongPressGestureRecognizer  {
                view.removeGestureRecognizer(recognizer)
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameSKScene.tap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameSKScene.longPress(_:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func positionInFrame(frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            cameraNode.position =  CGPoint(x: 0, y: 233)
            backgroundNode.position.x = 0
            robotNode.position = CGPoint(x: max(120,size.width * 0.3) , y: 180)
            robotNode.setScale(1)
        } else {
            cameraNode.position =  CGPoint(x: size.width / 2 - 190, y: 233)
            backgroundNode.position.x = cameraNode.position.x // 400
            robotNode.position = CGPoint(x: size.width * 0.6, y: 100) // 700
            robotNode.setScale(2)
        }      
        backgroundNode.size.width = size.width
        cameraRelativeOriginNode.position = -cameraNode.position
    }
    
    func tap(recognizer: UITapGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInScreen = cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: self)
        let positionInRobot = robotNode.convertPoint(positionInScene, fromNode: self)
        for experimentNode in experimentNodes {
            if experimentNode.containsPoint(positionInScene){
                play(experimentNode)
            }
        }
        if robotNode.containsPoint(positionInScreen) { // also includes the robotNode's child nodes
            robotNode.runAction(actionPress)
        }
        if CGRectContainsPoint(robotNode.frame, positionInScreen) {
            shiftButton()
        }
        if instructionButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showInstructionWindow()
        }
        if imagineButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showImagineWindow()
        }
        if gameCenterButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showGameCenter()
        }
        if levelButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showLevelWindow()
            levelButtonNode.unpulse()
        }
    }
    
    func shiftButton() {
        if currentButton.rawValue >= BUTTON.NONE.rawValue {
            currentButton = BUTTON.INSTRUCTION
        } else {
            currentButton = BUTTON(rawValue: currentButton.rawValue + 1)!
        }
        switch currentButton {
        case .INSTRUCTION:
            instructionButtonNode.appear()
        case .IMAGINE:
            instructionButtonNode.disappear()
            imagineButtonNode.appear()
        case .GAMECENTER:
            imagineButtonNode.disappear()
            gameCenterButtonNode.appear()
        case .LEVEL:
            gameCenterButtonNode.disappear()
            levelButtonNode.appear()
        default:
            levelButtonNode.disappear()
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
                if CGRectContainsPoint(experimentNode.frame, positionInScene) {
                    shapeNodeIndex = experimentNode.experiment.shapeIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveShapes), userInfo: nil, repeats: true)
                    editNode = experimentNode
                    shapeNodes.forEach({$0.lineWidth = 3})
                    shapeNodes[shapeNodeIndex].lineWidth = 6
                    addChild(shapePopupNode!)
                }
            }
            for experienceNode in experienceNodes {
                if CGRectContainsPoint(experienceNode.calculateAccumulatedFrame(), positionInScene) {
                    colorNodeIndex = experienceNode.experience.colorIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveColors), userInfo: nil, repeats: true)
                    editNode = experienceNode
                    colorPopupNode = gameModel.createColorPopup()
                    colorNodes = gameModel.createColorNodes(colorPopupNode!, experience: experienceNode.experience)
                    colorNodes.forEach({$0.lineWidth = 1})
                    colorNodes[colorNodeIndex].lineWidth = 6
                    cameraRelativeOriginNode.addChild(colorPopupNode!)
                }
            }
        case .Changed:
            if editNode != nil {
                if !CGRectContainsPoint(editNode!.calculateAccumulatedFrame(), positionInScene) {
                    timer?.invalidate()
                }
                selectShapeNode(positionInShapePopup)
                selectColorNode(positionInColorPopup)
            }
            break
        case .Ended:
            timer?.invalidate()
            selectShapeNode(positionInShapePopup)
            shapePopupNode?.removeFromParent()
            selectColorNode(positionInColorPopup)
            colorNodes = Array<SKShapeNode>()
            colorPopupNode?.removeFromParent()
            colorPopupNode = nil
            editNode = nil
        default:
            break
        }
    }
    
    func play(experimentNode: ExperimentSKNode) {
        
        clock += 1
        
        experimentNode.runAction(actionPress)
        
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
        robotNode.runAction(
            SKAction.animateWithTextures(texture, timePerFrame: 0.05, resize: false, restore: false))
    }
    
    func loadFrames(imageName: String, imageNumber: Int, by: Int) -> [SKTexture] {
        var frames = [SKTexture]()
        
        for i in 1.stride(to: imageNumber, by: by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        for i in imageNumber.stride(to: 0, by: -by) {
            let textureName = imageName + "\(i)"
            frames.append(SKTexture(imageNamed: textureName))
        }
        frames.append(SKTexture(imageNamed: imageName + "1"))
        return frames
    }
    
    func gaugeNode(score: Int) -> SKNode {
        let gaugeNode = SKNode()
        gaugeNode.position = CGPoint(x: -50, y: -40)
        var y = -70
        var height = 140
        if score < -10 {
            y = score * 6 - 10
            height = -score * 6 + 80
        }
        if score > 10 {
            height = score * 6 + 80
        }
        let gaugeBackgroundNode = SKShapeNode(rect: CGRect(x: -3, y: y, width: 10, height: height), cornerRadius: 5)
        gaugeBackgroundNode.zPosition = -1
        //gaugeBackgroundNode.fillColor = UIColor.whiteColor()
        gaugeBackgroundNode.lineWidth = 1
        gaugeNode.addChild(gaugeBackgroundNode)
        if score > 0 {
            for i in 1...score {
                let dotNode = SKShapeNode(rect: CGRect(x: -1, y: i * 6, width: 6, height: 4))
                dotNode.fillColor = UIColor.greenColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
        if score < 0 {
            for i in 1...(-score) {
                let dotNode = SKShapeNode(rect: CGRect(x: -1, y: -i * 6, width: 6, height: 4))
                dotNode.fillColor = UIColor.redColor()
                dotNode.lineWidth = 0
                gaugeNode.addChild(dotNode)
            }
        }
        return gaugeNode
    }
    
    func selectShapeNode(positionInShapePopup: CGPoint?) {
        for i in 0..<shapeNodes.count {
            if CGRectContainsPoint(shapeNodes[i].frame, positionInShapePopup!) {
                shapeNodes.forEach({$0.lineWidth = 3})
                shapeNodes[i].lineWidth = 6
                reshapeNodes(i)
            }
        }
    }
    func selectColorNode(positionInColorPopup: CGPoint?) {
        for i in 0..<colorNodes.count {
            if CGRectContainsPoint(colorNodes[i].frame, positionInColorPopup!) {
                colorNodes.forEach({$0.lineWidth = 1})
                colorNodes[i].lineWidth = 6
                refillNodes(i)
            }
        }
    }
    
    func revolveShapes() {
        shapeNodes[shapeNodeIndex].lineWidth = 3
        shapeNodeIndex += 1
        if shapeNodeIndex >= shapeNodes.count {
            shapeNodeIndex = 0
        }
        shapeNodes[shapeNodeIndex].lineWidth = 6
        reshapeNodes(shapeNodeIndex)
    }
    
    func reshapeNodes(shapeIndex: Int) {
        if let experimentNode = editNode as? ExperimentSKNode {
            experimentNode.experiment.shapeIndex = shapeIndex
            experimentNode.reshape()
            for node in experienceNodes {
                if node.experience.experimentNumber == experimentNode.experiment.number {
                    node.reshape()
                }
            }
        }
    }
    
    func revolveColors() {
        colorNodes[colorNodeIndex].lineWidth = 1
        colorNodeIndex += 1
        if colorNodeIndex >= colorNodes.count {
            colorNodeIndex = 0
        }
        colorNodes[colorNodeIndex].lineWidth = 6
        refillNodes(colorNodeIndex)
    }
    
    func refillNodes(colorIndex: Int) {
        if let experienceNode = editNode as? ExperienceSKNode {
            experienceNode.experience.colorIndex = colorIndex
            for node in experienceNodes {
                node.refill()
            }
        }
    }
}

