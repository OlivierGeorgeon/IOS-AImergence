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

//enum BUTTON: Int { case INSTRUCTION, IMAGINE, GAMECENTER, LEVEL, NONE}
enum BUTTON: Int { case INSTRUCTION, IMAGINE, GAMECENTER, NONE, LEVEL}

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
    
    let actionMoveTrace = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    let actionDisappear = SKAction.scaleTo(0, duration: 0.2)
    var nextExperimentNode: ExperimentSKNode?
    var nextExperimentClock = 0
    
    var currentButton = BUTTON.NONE
    
    weak var gameSceneDelegate: GameSceneDelegate!
    var experimentNodes = Dictionary<Int, ExperimentSKNode>()
    var eventNodes = Dictionary<Int, EventSKNode>()
    var clock:Int = 0
    
    let scoreNode = ScoreSKNode()
    
    var shapePopupNode:SKNode!
    var shapeNodes = Array<SKShapeNode>()
    var shapeNodeIndex = 0
    var colorPopupNode: SKNode?
    var colorNodes = Array<SKShapeNode>()
    var colorNodeIndex = 0
    var editNode: SKNode?
    var winMoves = 0
    var score = 0
    
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

        self.addChild(scoreNode)
        cameraRelativeOriginNode
        
        let scoreInOriginWindow = SKConstraint.positionY(SKRange(lowerLimit: 270, upperLimit: 270))
        scoreInOriginWindow.referenceNode = cameraNode
        let scoreAboveTenthEvent = SKConstraint.positionY(SKRange(upperLimit: 565))
        scoreNode.constraints = [scoreInOriginWindow, scoreAboveTenthEvent]
        //let moveOnTopOfScreen = SKConstraint.positionY(SKRange(lowerLimit: 270, upperLimit: 270))
        //moveOnTopOfScreen.referenceNode = cameraNode
        //scoreNode.moveNode.constraints = [moveOnTopOfScreen]

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
        
        actionMoveTrace.timingMode = .EaseInEaseOut
    }
    
    override func update(currentTime: NSTimeInterval) {
        if scoreNode.position.y == 565 {
            scoreNode.lineNode.hidden = false
        } else {
            scoreNode.lineNode.hidden = true
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            let locationInScoreNode = touch.locationInNode(scoreNode)
            if scoreNode.backgroundNode.containsPoint(locationInScoreNode) {
                scoreNode.moveNode.hidden = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        scoreNode.moveNode.hidden = true
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
            if nextExperimentNode != nil {
                if nextExperimentNode!.containsPoint(positionInScene) {
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
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInScreen = cameraRelativeOriginNode.convertPoint(positionInScene, fromNode: self)
        let positionInRobot = robotNode.convertPoint(positionInScene, fromNode: self)
        var playExperience = false
        for experimentNode in experimentNodes.values {
            if experimentNode.containsPoint(positionInScene){
                playExperience = true
                play(experimentNode)
                nextExperimentNode?.removeFromParent()
                nextExperimentNode = nil
            }
        }
        
        if nextExperimentNode != nil {
            if CGRectContainsPoint(CGRect(x: nextExperimentNode!.position.x - 30, y: nextExperimentNode!.position.y - 30, width: 60, height: 60), positionInScene) {
                let experience = play(experimentNodes[nextExperimentNode!.experiment.number]!)
                playExperience = true
                animNextExperiment(experience, nextClock: nextExperimentClock + 1)
            }
        }
        
        if !playExperience {
            for (clock, eventNode) in eventNodes {
                if eventNode.containsPoint(positionInScene) {
                    eventNode.runPressAction()
                    let experience = play(experimentNodes[eventNode.experienceNode.experience.experiment.number]!)
                    animNextExperiment(experience, nextClock: clock + 1)
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
    
    func animNextExperiment(experience: Experience, nextClock: Int) {
        
        if nextExperimentNode != nil && nextExperimentClock != nextClock - 1 {
            nextExperimentNode!.removeFromParent()
            nextExperimentNode = nil
        }
        if nextExperimentNode == nil {
            let rect = CGRect(x: -30, y: -30, width: 60, height: 60)
            nextExperimentNode = ExperimentSKNode(rect: rect, experiment: experience.experiment, gameModel: gameModel)
            nextExperimentNode!.zPosition = 2
            addChild(nextExperimentNode!)
        }
        nextExperimentNode!.position = CGPoint(x: -100, y: 40 + CGFloat(self.clock - nextClock + 1) * 50.0)
        nextExperimentNode!.fillColor = gameModel.experienceColors[experience.colorIndex]
        nextExperimentNode!.runAction(SKAction.sequence([actionDisappear, SKAction.removeFromParent()]))
        
        nextExperimentClock = nextClock

        let rect = CGRect(x: -30, y: -30, width: 60, height: 60)
        let nextExperiment = eventNodes[nextClock]!.experienceNode.experience.experiment
        nextExperimentNode = ExperimentSKNode(rect: rect, experiment: nextExperiment, gameModel: gameModel)
        nextExperimentNode!.position = CGPoint(x: -100, y: 40 + CGFloat(self.clock - nextClock + 1) * 50.0)
        nextExperimentNode!.hidden = true
        nextExperimentNode!.zPosition = 2
        addChild(nextExperimentNode!)
        nextExperimentNode?.runAction(SKAction.sequence([SKAction.scaleTo(0, duration: 0.2), SKAction.unhide(), SKAction.scaleTo(1, duration: 0.1)]))
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
            gameCenterButtonNode.disappear()
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
                    editNode = eventNode
                    colorPopupNode = gameModel.createColorPopup()
                    colorNodes = gameModel.createColorNodes(colorPopupNode!, experience: eventNode.experienceNode.experience)
                    colorNodes.forEach({$0.lineWidth = 1})
                    colorNodes[colorNodeIndex].lineWidth = 6
                    cameraRelativeOriginNode.addChild(colorPopupNode!)
                    eventNode.frameNode.hidden = false
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
            if let eventNode = editNode as? EventSKNode{
                eventNode.frameNode.hidden  = true
            }
            editNode = nil
        default:
            break
        }
    }
    
    func play(experimentNode: ExperimentSKNode) -> Experience {
        
        clock += 1
        
        experimentNode.runAction(actionPress)
        
        let experiment = experimentNode.experiment
        
        let(experience, score) = level.play(experiment)
        self.score = score
        if score >= level.winScore {
            if winMoves == 0 {
                gameSceneDelegate.unlockLevel(clock)
                winMoves = clock
                if imagineButtonNode.active {
                    imagineButtonNode.pulse()
                }
            }
            if !gameSceneDelegate.isImagineUnderstood() {
                if currentButton == BUTTON.INSTRUCTION {
                    shiftButton()
                }
            }
        }
        scoreNode.updateScore(score, clock: clock, winMoves: winMoves)

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
                eventNodes[clock]?.runAction(actionMoveTrace)
            }
        }

        let eventNode = EventSKNode(experience: experience, gameModel: gameModel)
        eventNode.position = experimentNode.position
        addChild(eventNode)
        eventNodes.updateValue(eventNode, forKey: clock)
        
        let actionIntroduce = SKAction.moveBy(gameModel.moveByVect(experimentNode.position), duration: 0.3)
        eventNode.experienceNode.runAction(gameModel.actionScale)
        eventNode.runAction(actionIntroduce, completion: {eventNode.addValenceNode()})
        
        return experience
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
            nextExperimentNode?.reshape()
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
        if let eventNode = editNode as? EventSKNode {
            eventNode.experienceNode.experience.colorIndex = colorIndex
            for node in eventNodes.values {
                node.refill()
            }
        }
    }
}

