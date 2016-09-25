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
    func playExperience(_ experience: Experience)
    func unlockLevel(_ score: Int)
    func isInterfaceLocked(_ interface: INTERFACE) -> Bool
    func showInstructionWindow()
    func showImagineWindow(_ gameModel: GameModel0)
    func updateImagineWindow(_ gameModel: GameModel0)
    func showGameCenter()
    func showLevelWindow()
    func isGameCenterEnabled() -> Bool
    func isSoundEnabled() -> Bool
    //func soundAction(_ soundIndex: Int) -> SKAction
}

class GameSKScene: PositionedSKScene {
    
    let gameModel:GameModel0
    let level:Level0
    let backgroundNode = SKSpriteNode(imageNamed: "fond.png")
    let robotNode = RobotSKNode()
    let cameraNode = SKCameraNode()
    let cameraRelativeOriginNode = SKNode()
    let actionDisappear = SKAction.scale(to: 0, duration: 0.2)
    let scoreNode = ScoreSKNode()
    let shapePopupNode: ShapePopupSKNode
    let colorPopupNode = ColorPopupSKNode()
    let traceNode = TraceSKNode()
    let tutorNode = TutorSKNode()
    let topRightNode = SKNode()
    
    weak var gameSceneDelegate: GameSceneDelegate!
    
    var timer: Timer?
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
        anchorPoint = CGPoint.zero
        scaleMode = .aspectFill
        name = "gameScene"
        
        backgroundColor = gameModel.backgroundColor
        self.addChild(traceNode)
        self.addChild(scoreNode)
        cameraNode.addChild(topRightNode)
        tutorNode.level = level.number
        switch self.level.number {
        case 0:
            tutorNode.tip(tutor: .instruction, parentNode: robotNode.instructionButtonNode)
        case 1:
            tutorNode.tip(tutor: .instruction, parentNode: robotNode.instructionButtonNode)
        case 3:
            tutorNode.tip(tutor: .shape, parentNode: scene!)
        default:
            break
        }
        
        let scoreInOriginWindow = SKConstraint.positionY(SKRange(lowerLimit: 540, upperLimit: 540))
        scoreInOriginWindow.referenceNode = cameraNode
        let scoreAboveTenthEvent = SKConstraint.positionY(SKRange(upperLimit: 1130))
        scoreNode.constraints = [scoreInOriginWindow, scoreAboveTenthEvent]

        shapePopupNode.isHidden = true
        addChild(shapePopupNode)
        colorPopupNode.isHidden = true
        cameraRelativeOriginNode.addChild(colorPopupNode)
        
        experimentNodes = createExperimentNodes()
        
        robotNode.position = CGPoint(x: 240, y: 360)
        cameraRelativeOriginNode.addChild(robotNode)
        //backgroundNode.size.height = 2376
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        cameraNode.addChild(backgroundNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if scoreNode.position.y == 1130 {
            scoreNode.lineNode.isHidden = false
        } else {
            scoreNode.lineNode.isHidden = true
        }
    }
    
    override func didMove(to view: SKView)
    {
        /* Setup your scene here */
        super.didMove(to: view)

        // The delegate is ready in didMoveToView
        if robotNode.recommendation == RECOMMEND.done {
            if gameSceneDelegate.isInterfaceLocked(INTERFACE.instruction) {
                robotNode.recommend(RECOMMEND.instruction)
            } else {
                if gameSceneDelegate.isInterfaceLocked(INTERFACE.imagine) {
                    if gameSceneDelegate.isInterfaceLocked(INTERFACE.level) {
                        robotNode.recommend(RECOMMEND.instruction_OK)
                    } else {
                        robotNode.recommend(RECOMMEND.imagine)
                    }
                } else if gameSceneDelegate.isInterfaceLocked(INTERFACE.leaderboard) && gameSceneDelegate.isGameCenterEnabled() {
                    robotNode.recommend(RECOMMEND.leaderboard)
                    robotNode.gameCenterButtonNode.pulse()
                }
            }
        }
        
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.instruction) {
            robotNode.instructionButtonNode.disactivate()
        }
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.imagine) {
            robotNode.imagineButtonNode.disactivate()
        }
        if !gameSceneDelegate.isInterfaceLocked(INTERFACE.leaderboard) {
            robotNode.gameCenterButtonNode.disactivate()
        }
        tutorNode.arrive()
    }
    
    override func positionInFrame(_ frameSize: CGSize) {
        super.positionInFrame(frameSize)
        if frameSize.height > frameSize.width {
            cameraNode.position =  CGPoint(x: 0, y: 466)
            robotNode.position = CGPoint(x: max(240,size.width * 0.3) , y: 365)
            robotNode.setScale(1)
        } else {
            cameraNode.position =  CGPoint(x: size.width / 2 - 380, y: 466)
            robotNode.position = CGPoint(x: size.width * 0.6, y: 140)
            robotNode.setScale(1.5)
        }      
        robotOrigin = robotNode.position.x
        backgroundNode.size.width = size.width
        cameraRelativeOriginNode.position = -cameraNode.position
        topRightNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    override func pan(_ recognizer: UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.view!)
        let velocity = recognizer.velocity(in: self.view!)

        switch recognizer.state {
        case .began:
            cameraNode.removeAction(forKey: "scroll")
        case .changed:
            if (view as! GameView).verticalPan {
                cameraNode.position.y += translation.y * sceneHeight / self.view!.frame.height
            } else {
                robotNode.position.x += translation.x * sceneHeight / self.view!.frame.height
                if robotNode.position.x <  robotOrigin * 0.9 {
                    robotNode.run(SKAction.moveTo(x: robotOrigin, duration: 0.2))
                    (self.view! as! GameView).nextLevel()
                    recognizer.isEnabled = false
                    recognizer.isEnabled = true
                }
                if robotNode.position.x > robotOrigin * 1.1 {
                    robotNode.run(SKAction.moveTo(x: robotOrigin, duration: 0.2))
                    (self.view! as! GameView).previousLevel()
                    recognizer.isEnabled = false
                    recognizer.isEnabled = true
                }
            }
        case .ended:
            if (view as! GameView).verticalPan {
                let acceleration = CGFloat(-20000)
                var scrollDuration = CGFloat(0.8)
                var translateY = velocity.y * CGFloat(scrollDuration) * 0.9 * sceneHeight / self.view!.frame.height
                if translateY > sceneHeight { translateY = sceneHeight }
                if translateY < -sceneHeight { translateY = -sceneHeight }

                if cameraNode.position.y + translateY > 466 {
                    let actionMoveCameraUp = SKAction.move(by: CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                    actionMoveCameraUp.timingMode = .easeOut
                    if abs(velocity.y) > 100 {
                        cameraNode.run(actionMoveCameraUp, withKey: "scroll")
                    }
                } else {
                    scrollDuration  =  abs(velocity.y / acceleration)
                    translateY = velocity.y * scrollDuration + acceleration * scrollDuration * scrollDuration / 2
                    if cameraNode.position.y > 466 {
                        translateY -= cameraNode.position.y - 466
                        scrollDuration += (cameraNode.position.y - 466) / abs(velocity.y)
                    }
                    let actionMoveCameraUp = SKAction.move(by: CGVector(dx: 0, dy: translateY), duration: Double(scrollDuration))
                    actionMoveCameraUp.timingMode = .easeOut
                    let moveToOrigin = SKAction.moveTo(y: 466, duration: 0.3)
                    moveToOrigin.timingMode = .easeInEaseOut
                    cameraNode.run(SKAction.sequence([actionMoveCameraUp, moveToOrigin]), withKey: "scroll")
                }
            } else {
                let moveRobotToOrigin = SKAction.moveTo(x: robotOrigin, duration: 0.2)
                moveRobotToOrigin.timingMode = .easeInEaseOut
                robotNode.run(moveRobotToOrigin)
            }
        default:
            break
        }
        recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view!)
    }
    
    override func tap(_ recognizer: UITapGestureRecognizer) {
        let positionInScene = self.convertPoint(fromView: recognizer.location(in: self.view))
        let positionInRobot = robotNode.convert(positionInScene, from: self)
        let positionInScore = scoreNode.convert(positionInScene, from: self)
        let positionInTrace = traceNode.convert(positionInScene, from: self)
        var playExperience = false
        var handlingTap = false
        
        cameraNode.removeAction(forKey: "scroll")

        for experimentNode in experimentNodes.values {
            if experimentNode.contains(positionInScene){
                playExperience = true
                _ = play(experimentNode)
                nextExperimentNode?.removeFromParent()
                nextExperimentNode = nil
                handlingTap = true
            }
        }
        
        if nextExperimentNode != nil {
            if CGRect(x: nextExperimentNode!.position.x - 60, y: nextExperimentNode!.position.y - 60, width: 120, height: 120).contains(positionInScene) {
                let experience = play(experimentNodes[nextExperimentNode!.experiment.number]!)
                playExperience = true
                animNextExperiment(experience, nextClock: nextExperimentClock + 1)
                handlingTap = true
                tutorNode.tapNextExperience()
            }
        }
        
        if !playExperience {
            for (clock, eventNode) in traceNode.eventNodes {
                if eventNode.contains(positionInTrace) {
                    eventNode.runPressAction()
                    let experience = play(experimentNodes[eventNode.experienceNode.experience.experiment.number]!)
                    animNextExperiment(experience, nextClock: clock + 1)
                    handlingTap = true
                    tutorNode.tapEvent(nextExperimentNode!)
                }
            }
        }
        if robotNode.imageNode.frame.contains(positionInRobot) {
            robotNode.imageNode.run(actionPress)
            robotNode.toggleButton()
            tutorNode.tapRobot(robotNode)
            handlingTap = true
        }
        if robotNode.instructionButtonNode.contains(positionInRobot) {
            gameSceneDelegate.showInstructionWindow()
            handlingTap = true
        }
        if robotNode.imagineButtonNode.contains(positionInRobot) {
            gameSceneDelegate.showImagineWindow(gameModel)
            handlingTap = true
        }
        if robotNode.gameCenterButtonNode.contains(positionInRobot) {
            gameSceneDelegate.showGameCenter()
            handlingTap = true
        }
        if scoreNode.backgroundNode.contains(positionInScore) {
            scoreNode.moveNode.isHidden = !scoreNode.moveNode.isHidden
            handlingTap = true
        } else {
            scoreNode.moveNode.isHidden = true
        }
        if handlingTap {
            (view as! GameView).doubleTapGesture.isEnabled = false
            (view as! GameView).doubleTapGesture.isEnabled = true
        }
    }
    
    func animNextExperiment(_ experience: Experience, nextClock: Int) {
        
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
        nextExperimentNode!.strokeColor = gameModel.experienceColors[experience.colorIndex]
        nextExperimentNode!.run(SKAction.sequence([actionDisappear, SKAction.removeFromParent()]))
        
        nextExperimentClock = nextClock

        let rect = CGRect(x: -60, y: -60, width: 120, height: 120)
        let nextExperiment = traceNode.eventNodes[nextClock]!.experienceNode.experience.experiment
        nextExperimentNode = ExperimentSKNode(rect: rect, experiment: nextExperiment, gameModel: gameModel)
        nextExperimentNode!.position = CGPoint(x: -200, y: 80 + CGFloat(self.clock - nextClock + 1) * 100)
        nextExperimentNode!.isHidden = true
        nextExperimentNode!.zPosition = 2
        addChild(nextExperimentNode!)
        nextExperimentNode?.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.2), SKAction.unhide(), SKAction.scale(to: 1, duration: 0.1)]))
    }
    
    
    override func longPress(_ recognizer: UILongPressGestureRecognizer)
    {
        let positionInScene = self.convertPoint(fromView: recognizer.location(in: self.view))
        let positionInShapePopup = shapePopupNode.convert(positionInScene, from: self)
        let positionInColorPopup = colorPopupNode.convert(positionInScene, from: self)
        let positionInTrace = traceNode.convert(positionInScene, from: self)

        cameraNode.removeAction(forKey: "scroll")

        switch recognizer.state {
        case .began:
            for experimentNode in experimentNodes.values {
                if experimentNode.frame.contains(positionInScene) {
                    let shapeNodeIndex = experimentNode.experiment.shapeIndex
                    timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(GameSKScene.revolveShapes), userInfo: nil, repeats: true)
                    editNode = experimentNode
                    shapePopupNode.position = experimentNode.position
                    shapePopupNode.update(shapeNodeIndex)
                    shapePopupNode.appear()
                }
            }
            for eventNode in traceNode.eventNodes.values {
                if eventNode.calculateAccumulatedFrame().contains(positionInTrace) {
                    let colorIndex = eventNode.experienceNode.experience.colorIndex
                    timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(GameSKScene.revolveColors), userInfo: nil, repeats: true)
                    editNode = eventNode
                    let pathFunc = gameModel.experimentPaths[eventNode.experienceNode.experience.experiment.shapeIndex]
                    colorPopupNode.createColorNodes(pathFunc, experienceColors: gameModel.experienceColors, colorIndex: colorIndex)
                    colorPopupNode.position = traceNode.convert(eventNode.position, to: cameraRelativeOriginNode)
                    colorPopupNode.appear()
                    eventNode.frameNode.isHidden = false
                }
            }
        case .changed:
            if editNode != nil {
                if !editNode!.calculateAccumulatedFrame().contains(positionInScene) {
                    //timer?.invalidate()
                }
                selectShapeNode(positionInShapePopup)
                selectColorNode(positionInColorPopup)
            }
            break
        case .ended:
            timer?.invalidate()
            selectShapeNode(positionInShapePopup)
            if let experimentNode = editNode as? ExperimentSKNode {
                shapePopupNode.disappear(experimentNode.position)
                tutorNode.longpressExperiment()
            }
            selectColorNode(positionInColorPopup)
            if let eventNode = editNode as? EventSKNode{
                colorPopupNode.disappear(traceNode.convert(eventNode.position, to: cameraRelativeOriginNode))
                eventNode.frameNode.isHidden  = true
                tutorNode.longpressEvent()
            }
            editNode = nil
        default:
            break
        }
    }
    
    func doubleTap(_ gesture:UITapGestureRecognizer) {
        // The doubeTapGesture is disabled if the tapGesture handles the tap.
        let actionScrollToOrigin = SKAction.move(by: CGVector(dx: 0.0, dy: 466 - cameraNode.position.y), duration: TimeInterval( cameraNode.position.y / 4000))
        actionScrollToOrigin.timingMode = .easeInEaseOut
        cameraNode.run(actionScrollToOrigin)
    }

    func play(_ experimentNode: ExperimentSKNode) -> Experience {
        
        clock += 1
        
        experimentNode.run(actionPress)
        
        let experiment = experimentNode.experiment
        let(experience, score) = level.play(experiment)
        
        let eventNode = EventSKNode(experience: experience, gameModel: gameModel)
        eventNode.position = traceNode.convert(experimentNode.position, from: scene!)
        traceNode.addEvent(clock, eventNode: eventNode)
        
        if gameSceneDelegate.isSoundEnabled() {
            let soundIndex = gameModel.sounds[experience.experimentNumber][experience.resultNumber]
            if soundIndex < 13 {
                run(SKAction.playSoundFileNamed("baby\(soundIndex).wav", waitForCompletion: false))
            }
            //run(gameSceneDelegate.soundAction(gameModel.sounds[experience.experimentNumber][experience.resultNumber]))
        }
        
        self.score = score
        if score >= level.winScore {
            tutorNode.reachTen(robotNode.imagineButtonNode, level3ParentNode: topRightNode)
            if winMoves == 0 {
                gameSceneDelegate.unlockLevel(clock)
                winMoves = clock
                robotNode.gameCenterButtonNode.activate()
                gameSceneDelegate.updateImagineWindow(gameModel)
            }
            if robotNode.recommendation == RECOMMEND.instruction_OK {
                robotNode.recommend(RECOMMEND.imagine)
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
    
    func selectShapeNode(_ positionInShapePopup: CGPoint?) {
        for i in 0..<shapePopupNode.shapeNodes.count {
            if shapePopupNode.shapeNodes[i].frame.contains(positionInShapePopup!) {
                shapePopupNode.shapeNodes.forEach({$0.lineWidth = 6})
                shapePopupNode.shapeNodes[i].lineWidth = 12
                reshapeNodes(i)
                timer?.invalidate()
            }
        }
    }
    func selectColorNode(_ positionInColorPopup: CGPoint?) {
        for i in 0..<colorPopupNode.colorNodes.count {
            if colorPopupNode.colorNodes[i].frame.contains(positionInColorPopup!) {
                colorPopupNode.colorNodes.forEach({$0.lineWidth = 4})
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
    
    func reshapeNodes(_ shapeIndex: Int) {
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

    func refillNodes(_ colorIndex: Int) {
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

