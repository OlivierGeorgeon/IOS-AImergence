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
    
    var activeEventNode: EventSKNode?
    
    var currentButton = BUTTON.NONE
    
    weak var gameSceneDelegate: GameSceneDelegate!
    var experimentNodes = Dictionary<Int, ExperimentSKNode>()
    var eventNodes = Dictionary<Int, EventSKNode>()
    var clock:Int = 0
    var scoreLabel:SKLabelNode
    var scoreBackground:SKShapeNode
    var shapePopupNode:SKNode!
    var shapeNodes = Array<SKShapeNode>()
    var shapeNodeIndex = 0
    var scoreLine:SKShapeNode?
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
                scoreLine?.strokeColor = UIColor.greenColor()
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
                if won {
                    scoreBackground.fillColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
                    scoreLine?.strokeColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
                } else {
                    scoreBackground.fillColor = UIColor.whiteColor()
                    scoreLine?.strokeColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    var robotHappyFrames: [SKTexture]!
    var robotSadFrames: [SKTexture]!
    var robotBlinkFrames: [SKTexture]!
    
    var robotPan = false
    var robotOrigin = CGFloat(0.0)
    var horizontalPan = false
    
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
        let scoreInOriginWindow = SKConstraint.positionY(SKRange(lowerLimit: 270, upperLimit: 270))
        scoreInOriginWindow.referenceNode = cameraNode
        let scoreAboveTenthEvent = SKConstraint.positionY(SKRange(upperLimit: 565))
        scoreBackground.constraints = [scoreInOriginWindow, scoreAboveTenthEvent]
        
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        scoreLine = SKShapeNode(path:pathToDraw)
        CGPathMoveToPoint(pathToDraw, nil, 0, 0)
        CGPathAddLineToPoint(pathToDraw, nil, 178, 0)
        scoreLine!.path = pathToDraw
        scoreLine!.strokeColor = SKColor.whiteColor()
        scoreLine!.zPosition = -1
        scoreLine!.hidden = true
        scoreBackground.addChild(scoreLine!)
        
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
    
    override func update(currentTime: NSTimeInterval) {
        if scoreBackground.position.y == 565 {
            scoreLine?.hidden = false
        } else {
            scoreLine?.hidden = true
        }
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
        robotOrigin = robotNode.position.x
        backgroundNode.size.width = size.width
        cameraRelativeOriginNode.position = -cameraNode.position
    }
    
    override func pan(recognizer: UIPanGestureRecognizer) {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInScreen = cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: self)
        let translation  = recognizer.translationInView(self.view!)

        switch recognizer.state {
        case .Began:
            for experimentNode in experimentNodes.values {
                if experimentNode.containsPoint(positionInScene){
                    recognizer.enabled = false
                    recognizer.enabled = true
                }
            }
            cameraNode.removeActionForKey("scroll")
            robotPan = robotNode.containsPoint(positionInScreen) && abs(translation.x) > abs(translation.y)
        case .Changed:
            if robotPan {
                robotNode.position.x += translation.x * 667 / self.view!.frame.height
                if robotNode.position.x <  robotOrigin * 0.9 {
                    robotNode.runAction(SKAction.moveToX(robotOrigin, duration: 0.2))
                    (self.view! as! GameView).nextLevel()
                    recognizer.enabled = false
                    recognizer.enabled = true
                }
                if robotNode.position.x > robotOrigin * 1.1 {
                    robotNode.runAction(SKAction.moveToX(robotOrigin, duration: 0.2))
                    (self.view! as! GameView).previousLevel()
                    recognizer.enabled = false
                    recognizer.enabled = true
                }
            } else {
                cameraNode.position.y += translation.y * 667 / self.view!.frame.height
            }
        case .Ended:
            if robotPan {
                robotNode.runAction(SKAction.moveToX(robotOrigin, duration: 0.2))
            } else {
                let acceleration = CGFloat(-10000.0)
                    var scrollDuration = CGFloat(0.8)
                    let velocity = recognizer.velocityInView(self.view!)
                    var translateY = velocity.y * CGFloat(scrollDuration) * 0.9 * 667 / self.view!.frame.height
                    if translateY > 667 { translateY = 667 }
                    if translateY < -667 { translateY = -667 }

                    if cameraNode.position.y + translateY > 233 {
                        let actionMoveCameraUp = SKAction.moveBy(CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                        actionMoveCameraUp.timingMode = .EaseOut
                        cameraNode.runAction(actionMoveCameraUp, withKey: "scroll")
                    } else {
                        scrollDuration  =  abs(velocity.y / acceleration)
                        translateY = velocity.y * scrollDuration + acceleration * scrollDuration * scrollDuration / 2
                        if cameraNode.position.y > 233 {
                            translateY -= cameraNode.position.y - 233
                            scrollDuration += (cameraNode.position.y - 233) / abs(velocity.y)
                        }
                        let actionMoveCameraUp = SKAction.moveBy(CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                        actionMoveCameraUp.timingMode = .EaseOut
                        let moveToOrigin = SKAction.moveToY(233, duration: 0.3)
                        moveToOrigin.timingMode = .EaseInEaseOut
                        cameraNode.runAction(SKAction.sequence([actionMoveCameraUp, moveToOrigin]), withKey: "scroll")
                    }
            }
        default:
            break
        }
        recognizer.setTranslation(CGPoint(x: 0,y: 0), inView: self.view!)
    }
    
    override func tap(recognizer: UITapGestureRecognizer) {
        activeEventNode?.removeActionForKey("active")
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInScreen = cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: self)
        let positionInRobot = robotNode.convertPoint(positionInScene, fromNode: self)
        var playExperience = false
        for experimentNode in experimentNodes.values {
            if experimentNode.containsPoint(positionInScene){
                playExperience = true
                play(experimentNode)
            }
        }
        if !playExperience {
            for eventNode in eventNodes.values {
                if CGRectContainsPoint(eventNode.calculateAccumulatedFrame(), positionInScene) {
                    //experienceNode.runAction(actionActive, withKey: "active")
                    activeEventNode = eventNode
                    play(experimentNodes[eventNode.experienceNode.experience.experiment.number]!)
                }
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
    
    override func longPress(recognizer: UILongPressGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInShapePopup = shapePopupNode?.convertPoint(positionInScene, fromNode: self)
        let positionInColorPopup = colorPopupNode?.convertPoint(positionInScene, fromNode: self)

        switch recognizer.state {
        case .Began:
            for experimentNode in experimentNodes.values {
                if CGRectContainsPoint(experimentNode.frame, positionInScene) {
                    shapeNodeIndex = experimentNode.experiment.shapeIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveShapes), userInfo: nil, repeats: true)
                    editNode = experimentNode
                    shapeNodes.forEach({$0.lineWidth = 3})
                    shapeNodes[shapeNodeIndex].lineWidth = 6
                    addChild(shapePopupNode!)
                }
            }
            for eventNode in eventNodes.values {
                if CGRectContainsPoint(eventNode.calculateAccumulatedFrame(), positionInScene) {
                    colorNodeIndex = eventNode.experienceNode.experience.colorIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveColors), userInfo: nil, repeats: true)
                    editNode = eventNode.experienceNode
                    colorPopupNode = gameModel.createColorPopup()
                    colorNodes = gameModel.createColorNodes(colorPopupNode!, experience: eventNode.experienceNode.experience)
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
        
        for clock in eventNodes.keys {
            if clock < self.clock - gameModel.obsolescence {
                eventNodes[clock]?.removeFromParent()
                eventNodes.removeValueForKey(clock)
            } else {
                eventNodes[clock]?.runAction(gameModel.actionMoveTrace)
            }
        }

        let eventNode = EventSKNode(experience: experience, gameModel: gameModel)
        eventNode.position = experimentNode.position
        addChild(eventNode)
        eventNodes.updateValue(eventNode, forKey: clock)
        
        let actionIntroduce = SKAction.moveBy(gameModel.moveByVect(experimentNode.position), duration: 0.3)
        eventNode.experienceNode.runAction(gameModel.actionScale)
        eventNode.runAction(actionIntroduce, completion: {eventNode.addValenceNode()})
        
        //let groupIntruduce = SKAction.group([actionIntroduce, gameModel.actionScale])
        //eventNode.runAction(groupIntruduce, completion: {eventNode.addValenceNode()})
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
            for node in eventNodes.values {
                if node.experienceNode.experience.experimentNumber == experimentNode.experiment.number {
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
            for node in eventNodes.values {
                node.refill()
            }
        }
    }
}

