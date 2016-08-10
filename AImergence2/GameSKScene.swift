//
//  GameScene.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit
import AudioToolbox
import AVFoundation

protocol GameSceneDelegate: class
{
    func playExperience(experience: Experience)
    func unlockLevel(score: Int)
    func isInterfaceLocked(interface: INTERFACE) -> Bool
    func showInstructionWindow()
    func showImagineWindow(gameModel: GameModel0)
    func updateImagineWindow(gameModel: GameModel0)
    func showGameCenter()
    func showLevelWindow()
    func isGameCenterEnabled() -> Bool
    func isSoundEnabled() -> Bool
    func soundAction(soundIndex: Int) -> SKAction
}

class GameSKScene: PositionedSKScene {
    
    let gameModel:GameModel0
    let level:Level0
    let backgroundNode = SKSpriteNode(imageNamed: "fond.png")
    let robotNode = RobotSKNode()
    let cameraNode = SKCameraNode()
    let cameraRelativeOriginNode = SKNode()
    let actionDisappear = SKAction.scaleTo(0, duration: 0.2)
    let scoreNode = ScoreSKNode()
    let shapePopupNode: ShapePopupSKNode
    let colorPopupNode = ColorPopupSKNode()
    let traceNode = TraceSKNode()
    let tutorNode = TutorSKNode()
    let topRightNode = SKNode()
    
    weak var gameSceneDelegate: GameSceneDelegate!
    
    var timer: NSTimer?
    var nextExperimentNode: ExperimentSKNode?
    var nextExperimentClock = 0
    var experimentNodes = Dictionary<Int, ExperimentSKNode>()
    var clock:Int = 0
    var editNode: SKNode?
    var winMoves = 0
    var score = 0
    var robotOrigin = CGFloat(0.0)
    
    init(levelNumber: Int)
    {
        //let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let aClass:AnyClass? =  NSClassFromString("Little_AI.Level\(levelNumber)")
        if let levelType = aClass as? Level0.Type {
            level = levelType.init()
        } else {
            level = Level0()
        }
        let gameModelString = level.gameModelString
        let aClass2:AnyClass? =  NSClassFromString("Little_AI." + gameModelString)
        if let gameModelType = aClass2 as? GameModel0.Type {
            gameModel = gameModelType.init()
        } else {
            gameModel = GameModel0()
        }
        
        gameModel.level = level
        self.shapePopupNode = ShapePopupSKNode(gameModel: gameModel)
        
        super.init(size:CGSize(width: 0 , height: 0))
        
        self.camera = cameraNode
        self.addChild(cameraNode)
        cameraNode.addChild(cameraRelativeOriginNode)
        layoutScene()
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.level = Level0()
        self.gameModel = GameModel0()
        self.shapePopupNode = ShapePopupSKNode(gameModel: gameModel)

        super.init(coder: aDecoder)
        layoutScene()
    }
    
    func layoutScene()
    {
        anchorPoint = CGPointZero
        scaleMode = .AspectFill
        name = "gameScene"
        
        backgroundColor = gameModel.backgroundColor
        self.addChild(traceNode)
        self.addChild(scoreNode)
        cameraNode.addChild(topRightNode)
        tutorNode.level = level.number
        switch self.level.number {
        case 0:
            tutorNode.tip(0, parentNode: scene!)
        case 1:
            tutorNode.tip(2, parentNode: robotNode.instructionButtonNode)
        case 3:
            tutorNode.tip(8, parentNode: scene!)
        default:
            break
        }
        
        let scoreInOriginWindow = SKConstraint.positionY(SKRange(lowerLimit: 540, upperLimit: 540))
        scoreInOriginWindow.referenceNode = cameraNode
        let scoreAboveTenthEvent = SKConstraint.positionY(SKRange(upperLimit: 1130))
        scoreNode.constraints = [scoreInOriginWindow, scoreAboveTenthEvent]

        shapePopupNode.hidden = true
        addChild(shapePopupNode)
        colorPopupNode.hidden = true
        cameraRelativeOriginNode.addChild(colorPopupNode)
        
        experimentNodes = createExperimentNodes()
        
        robotNode.position = CGPoint(x: 240, y: 360)
        cameraRelativeOriginNode.addChild(robotNode)
        backgroundNode.size.height = 2376
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        cameraRelativeOriginNode.addChild(backgroundNode)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if scoreNode.position.y == 1130 {
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
        if robotNode.recommendation == RECOMMEND.DONE {
            if gameSceneDelegate.isInterfaceLocked(INTERFACE.INSTRUCTION) {
                robotNode.recommend(RECOMMEND.INSTRUCTION)
            } else {
                if gameSceneDelegate.isInterfaceLocked(INTERFACE.IMAGINE) {
                    if gameSceneDelegate.isInterfaceLocked(INTERFACE.LEVEL) {
                        robotNode.recommend(RECOMMEND.INSTRUCTION_OK)
                    } else {
                        robotNode.recommend(RECOMMEND.IMAGINE)
                    }
                } else if gameSceneDelegate.isInterfaceLocked(INTERFACE.LEADERBOARD) && gameSceneDelegate.isGameCenterEnabled() {
                    robotNode.recommend(RECOMMEND.LEADERBOARD)
                    robotNode.gameCenterButtonNode.pulse()
                }
            }
        }
        
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.INSTRUCTION) {
            robotNode.instructionButtonNode.disactivate()
        }
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.IMAGINE) {
            robotNode.imagineButtonNode.disactivate()
        }
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.LEADERBOARD) {
            robotNode.gameCenterButtonNode.disactivate()
        }
        tutorNode.arrive()
    }
    
    override func positionInFrame(frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            cameraNode.position =  CGPoint(x: 0, y: 466)
            backgroundNode.position.x = 0
            robotNode.position = CGPoint(x: max(240,size.width * 0.3) , y: 360)
            robotNode.setScale(1)
        } else {
            cameraNode.position =  CGPoint(x: size.width / 2 - 380, y: 466)
            backgroundNode.position.x = cameraNode.position.x
            robotNode.position = CGPoint(x: size.width * 0.6, y: 140)
            robotNode.setScale(1.5)
        }      
        robotOrigin = robotNode.position.x
        backgroundNode.size.width = size.width
        //backgroundNode.size = size
        cameraRelativeOriginNode.position = -cameraNode.position
        topRightNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    override func pan(recognizer: UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(self.view!)
        let velocity = recognizer.velocityInView(self.view!)

        switch recognizer.state {
        case .Began:
            cameraNode.removeActionForKey("scroll")
        case .Changed:
            if (view as! GameView).verticalPan {
                cameraNode.position.y += translation.y * sceneHeight / self.view!.frame.height
            } else {
                robotNode.position.x += translation.x * sceneHeight / self.view!.frame.height
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
            }
        case .Ended:
            if (view as! GameView).verticalPan {
                let acceleration = CGFloat(-10000.0)
                var scrollDuration = CGFloat(0.8)
                var translateY = velocity.y * CGFloat(scrollDuration) * 0.9 * sceneHeight / self.view!.frame.height
                if translateY > sceneHeight { translateY = sceneHeight }
                if translateY < -sceneHeight { translateY = -sceneHeight }

                if cameraNode.position.y + translateY > 466 {
                    let actionMoveCameraUp = SKAction.moveBy(CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                    actionMoveCameraUp.timingMode = .EaseOut
                    cameraNode.runAction(actionMoveCameraUp, withKey: "scroll")
                } else {
                    scrollDuration  =  abs(velocity.y / acceleration)
                    translateY = velocity.y * scrollDuration + acceleration * scrollDuration * scrollDuration / 2
                    if cameraNode.position.y > 466 {
                        translateY -= cameraNode.position.y - 466
                        scrollDuration += (cameraNode.position.y - 466) / abs(velocity.y)
                    }
                    let actionMoveCameraUp = SKAction.moveBy(CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                    actionMoveCameraUp.timingMode = .EaseOut
                    let moveToOrigin = SKAction.moveToY(466, duration: 0.3)
                    moveToOrigin.timingMode = .EaseInEaseOut
                    cameraNode.runAction(SKAction.sequence([actionMoveCameraUp, moveToOrigin]), withKey: "scroll")
                }
            } else {
                let moveRobotToOrigin = SKAction.moveToX(robotOrigin, duration: 0.2)
                moveRobotToOrigin.timingMode = .EaseInEaseOut
                robotNode.runAction(moveRobotToOrigin)
            }
        default:
            break
        }
        recognizer.setTranslation(CGPoint(x: 0,y: 0), inView: self.view!)
    }
    
    override func tap(recognizer: UITapGestureRecognizer) {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInRobot = robotNode.convertPoint(positionInScene, fromNode: self)
        let positionInScore = scoreNode.convertPoint(positionInScene, fromNode: self)
        let positionInTrace = traceNode.convertPoint(positionInScene, fromNode: self)
        var playExperience = false
        var handlingTap = false
        for experimentNode in experimentNodes.values {
            if experimentNode.containsPoint(positionInScene){
                playExperience = true
                play(experimentNode)
                nextExperimentNode?.removeFromParent()
                nextExperimentNode = nil
                handlingTap = true
            }
        }
        
        if nextExperimentNode != nil {
            if CGRectContainsPoint(CGRect(x: nextExperimentNode!.position.x - 60, y: nextExperimentNode!.position.y - 60, width: 120, height: 120), positionInScene) {
                let experience = play(experimentNodes[nextExperimentNode!.experiment.number]!)
                playExperience = true
                animNextExperiment(experience, nextClock: nextExperimentClock + 1)
                handlingTap = true
                tutorNode.tapNextExperience()
            }
        }
        
        if !playExperience {
            for (clock, eventNode) in traceNode.eventNodes {
                if eventNode.containsPoint(positionInTrace) {
                    eventNode.runPressAction()
                    let experience = play(experimentNodes[eventNode.experienceNode.experience.experiment.number]!)
                    animNextExperiment(experience, nextClock: clock + 1)
                    handlingTap = true
                    tutorNode.tapEvent(nextExperimentNode!)
                }
            }
        }
        if CGRectContainsPoint(robotNode.imageNode.frame, positionInRobot) {
            robotNode.imageNode.runAction(actionPress)
            robotNode.toggleButton()
            tutorNode.tapRobot(robotNode)
            handlingTap = true
        }
        if robotNode.instructionButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showInstructionWindow()
            handlingTap = true
        }
        if robotNode.imagineButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showImagineWindow(gameModel)
            handlingTap = true
        }
        if robotNode.gameCenterButtonNode.containsPoint(positionInRobot) {
            gameSceneDelegate.showGameCenter()
            handlingTap = true
        }
        if scoreNode.backgroundNode.containsPoint(positionInScore) {
            scoreNode.moveNode.hidden = !scoreNode.moveNode.hidden
            handlingTap = true
        } else {
            scoreNode.moveNode.hidden = true
        }
        if handlingTap {
            (view as! GameView).doubleTapGesture.enabled = false
            (view as! GameView).doubleTapGesture.enabled = true
        }
    }
    
    func animNextExperiment(experience: Experience, nextClock: Int) {
        
        if nextExperimentNode != nil && nextExperimentClock != nextClock - 1 {
            nextExperimentNode!.removeFromParent()
            nextExperimentNode = nil
        }
        if nextExperimentNode == nil {
            let rect = CGRect(x: -60, y: -60, width: 120, height: 120)
            nextExperimentNode = ExperimentSKNode(rect: rect, experiment: experience.experiment, gameModel: gameModel)
            nextExperimentNode!.zPosition = 2
            addChild(nextExperimentNode!)
        }
        nextExperimentNode!.position = CGPoint(x: -200, y: 80 + CGFloat(self.clock - nextClock + 1) * 100)
        nextExperimentNode!.fillColor = gameModel.experienceColors[experience.colorIndex]
        nextExperimentNode!.runAction(SKAction.sequence([actionDisappear, SKAction.removeFromParent()]))
        
        nextExperimentClock = nextClock

        let rect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let nextExperiment = traceNode.eventNodes[nextClock]!.experienceNode.experience.experiment
        nextExperimentNode = ExperimentSKNode(rect: rect, experiment: nextExperiment, gameModel: gameModel)
        nextExperimentNode!.position = CGPoint(x: -200, y: 80 + CGFloat(self.clock - nextClock + 1) * 100)
        nextExperimentNode!.hidden = true
        nextExperimentNode!.zPosition = 2
        addChild(nextExperimentNode!)
        nextExperimentNode?.runAction(SKAction.sequence([SKAction.scaleTo(0, duration: 0.2), SKAction.unhide(), SKAction.scaleTo(1, duration: 0.1)]))
    }
    
    
    override func longPress(recognizer: UILongPressGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInShapePopup = shapePopupNode.convertPoint(positionInScene, fromNode: self)
        let positionInColorPopup = colorPopupNode.convertPoint(positionInScene, fromNode: self)
        let positionInTrace = traceNode.convertPoint(positionInScene, fromNode: self)

        switch recognizer.state {
        case .Began:
            for experimentNode in experimentNodes.values {
                if CGRectContainsPoint(experimentNode.frame, positionInScene) {
                    let shapeNodeIndex = experimentNode.experiment.shapeIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveShapes), userInfo: nil, repeats: true)
                    editNode = experimentNode
                    shapePopupNode.position = experimentNode.position
                    shapePopupNode.update(shapeNodeIndex)
                    shapePopupNode.appear()
                }
            }
            for eventNode in traceNode.eventNodes.values {
                if CGRectContainsPoint(eventNode.calculateAccumulatedFrame(), positionInTrace) {
                    let colorIndex = eventNode.experienceNode.experience.colorIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveColors), userInfo: nil, repeats: true)
                    editNode = eventNode
                    let pathFunc = gameModel.experimentPaths[eventNode.experienceNode.experience.experiment.shapeIndex]
                    colorPopupNode.createColorNodes(pathFunc, experienceColors: gameModel.experienceColors, colorIndex: colorIndex)
                    colorPopupNode.position = traceNode.convertPoint(eventNode.position, toNode: cameraRelativeOriginNode)
                    colorPopupNode.appear()
                    eventNode.frameNode.hidden = false
                }
            }
        case .Changed:
            if editNode != nil {
                if !CGRectContainsPoint(editNode!.calculateAccumulatedFrame(), positionInScene) {
                    //timer?.invalidate()
                }
                selectShapeNode(positionInShapePopup)
                selectColorNode(positionInColorPopup)
            }
            break
        case .Ended:
            timer?.invalidate()
            selectShapeNode(positionInShapePopup)
            if let experimentNode = editNode as? ExperimentSKNode {
                shapePopupNode.disappear(experimentNode.position)
                tutorNode.longpressExperiment()
            }
            selectColorNode(positionInColorPopup)
            if let eventNode = editNode as? EventSKNode{
                colorPopupNode.disappear(traceNode.convertPoint(eventNode.position, toNode: cameraRelativeOriginNode))
                eventNode.frameNode.hidden  = true
                tutorNode.longpressEvent()
            }
            editNode = nil
        default:
            break
        }
    }
    
    func doubleTap(gesture:UITapGestureRecognizer) {
        // The doubeTapGesture is disabled if the tapGesture handles the tap.
        let actionScrollToOrigin = SKAction.moveBy(CGVector(dx: 0.0, dy: 466 - cameraNode.position.y), duration: NSTimeInterval( cameraNode.position.y / 4000))
        actionScrollToOrigin.timingMode = .EaseInEaseOut
        cameraNode.runAction(actionScrollToOrigin)
    }

    func play(experimentNode: ExperimentSKNode) -> Experience {
        
        clock += 1
        
        experimentNode.runAction(actionPress)
        
        let experiment = experimentNode.experiment
        let(experience, score) = level.play(experiment)
        
        let eventNode = EventSKNode(experience: experience, gameModel: gameModel)
        eventNode.position = traceNode.convertPoint(experimentNode.position, fromNode: scene!)
        traceNode.addEvent(clock, eventNode: eventNode)
        
        if gameSceneDelegate.isSoundEnabled() {
            runAction(gameSceneDelegate.soundAction(gameModel.sounds[experience.experimentNumber][experience.resultNumber]))
        }
        
        self.score = score
        if score >= level.winScore {
            tutorNode.reachTen(robotNode.instructionButtonNode, level3ParentNode: topRightNode)
            if winMoves == 0 {
                gameSceneDelegate.unlockLevel(clock)
                winMoves = clock
                robotNode.gameCenterButtonNode.activate()
                gameSceneDelegate.updateImagineWindow(gameModel)
            }
            if robotNode.recommendation == RECOMMEND.INSTRUCTION_OK {
                robotNode.recommend(RECOMMEND.IMAGINE)
            }
        }
        if winMoves == clock {
            robotNode.animRobot(10)
        } else {
            robotNode.animRobot(experience.valence)
        }

        scoreNode.updateScore(score, clock: clock, winMoves: winMoves)
        
        gameSceneDelegate.playExperience(experience)
        
        tutorNode.tapCommand(experience.experimentNumber, nextParentNode: scoreNode)
        
        return experience
    }
    
    func selectShapeNode(positionInShapePopup: CGPoint?) {
        for i in 0..<shapePopupNode.shapeNodes.count {
            if CGRectContainsPoint(shapePopupNode.shapeNodes[i].frame, positionInShapePopup!) {
                shapePopupNode.shapeNodes.forEach({$0.lineWidth = 6})
                shapePopupNode.shapeNodes[i].lineWidth = 12
                reshapeNodes(i)
                timer?.invalidate()
            }
        }
    }
    func selectColorNode(positionInColorPopup: CGPoint?) {
        for i in 0..<colorPopupNode.colorNodes.count {
            if CGRectContainsPoint(colorPopupNode.colorNodes[i].frame, positionInColorPopup!) {
                colorPopupNode.colorNodes.forEach({$0.lineWidth = 2})
                colorPopupNode.colorNodes[i].lineWidth = 12
                refillNodes(i)
                timer?.invalidate()
            }
        }
    }
    
    func revolveShapes() {
        shapePopupNode.revolve()
        reshapeNodes(shapePopupNode.shapeIndex)
    }
    
    func reshapeNodes(shapeIndex: Int) {
        if let experimentNode = editNode as? ExperimentSKNode {
            experimentNode.experiment.shapeIndex = shapeIndex
            experimentNode.reshape()
            for node in traceNode.eventNodes.values {
                if node.experienceNode.experience.experimentNumber == experimentNode.experiment.number {
                    node.reshape()
                }
            }
            nextExperimentNode?.reshape()
        }
    }

    func revolveColors() {
        colorPopupNode.revolve()
        refillNodes(colorPopupNode.colorIndex)
    }

    func refillNodes(colorIndex: Int) {
        if let eventNode = editNode as? EventSKNode {
            eventNode.experienceNode.experience.colorIndex = colorIndex
            for node in traceNode.eventNodes.values {
                node.refill()
            }
        }
    }
    func createExperimentNodes() -> Dictionary<Int, ExperimentSKNode> {
        var experimentNodes = Dictionary<Int, ExperimentSKNode>()
        for i in 0..<level.experiments.count {
            let experimentNode = ExperimentSKNode(gameModel: gameModel, experiment: level.experiments[i])
            experimentNode.position = gameModel.experimentPositions[i]
            self.addChild(experimentNode)
            experimentNodes.updateValue(experimentNode, forKey: experimentNode.experiment.number)
        }
        return experimentNodes
    }
}

