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
    func isInterfaceLocked(interface: INTERFACE) -> Bool
    func showInstructionWindow()
    func showImagineWindow(gameModel: GameModel0)
    func showGameCenter()
    func showLevelWindow()
    func isGameCenterEnabled() -> Bool
}

class GameSKScene: PositionedSKScene {
    
    let gameModel:GameModel0
    let level:Level0
    let backgroundNode = SKSpriteNode(imageNamed: "fond.png")
    let robotNode = RobotSKNode()
    let cameraNode = SKCameraNode()
    let cameraRelativeOriginNode = SKNode()
    let actionMoveTrace = SKAction.moveBy(CGVector(dx:0, dy:50), duration: 0.3)
    let actionDisappear = SKAction.scaleTo(0, duration: 0.2)
    let scoreNode = ScoreSKNode()
    
    weak var gameSceneDelegate: GameSceneDelegate!

    var timer: NSTimer?
    var nextExperimentNode: ExperimentSKNode?
    var nextExperimentClock = 0
    var experimentNodes = Dictionary<Int, ExperimentSKNode>()
    var eventNodes = Dictionary<Int, EventSKNode>()
    var clock:Int = 0
    let shapePopupNode: ShapePopupSKNode
    //var shapeNodes = Array<SKShapeNode>()
    //var shapeNodeIndex = 0
    var colorPopupNode = ColorPopupSKNode()
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

        self.addChild(scoreNode)
        //cameraRelativeOriginNode
        
        let scoreInOriginWindow = SKConstraint.positionY(SKRange(lowerLimit: 270, upperLimit: 270))
        scoreInOriginWindow.referenceNode = cameraNode
        let scoreAboveTenthEvent = SKConstraint.positionY(SKRange(upperLimit: 565))
        scoreNode.constraints = [scoreInOriginWindow, scoreAboveTenthEvent]
        //let moveOnTopOfScreen = SKConstraint.positionY(SKRange(lowerLimit: 270, upperLimit: 270))
        //moveOnTopOfScreen.referenceNode = cameraNode
        //scoreNode.moveNode.constraints = [moveOnTopOfScreen]

        //shapePopupNode = gameModel.createShapePopup()
        //shapeNodes = gameModel.createShapeNodes(shapePopupNode)
        shapePopupNode.hidden = true
        addChild(shapePopupNode)
        colorPopupNode.hidden = true
        cameraRelativeOriginNode.addChild(colorPopupNode)
        
        experimentNodes = createExperimentNodes()
        
        robotNode.position = CGPoint(x: 120, y: 180)
        cameraRelativeOriginNode.addChild(robotNode)
        backgroundNode.zPosition = -20
        backgroundNode.name = "background"
        cameraRelativeOriginNode.addChild(backgroundNode)
        
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
            robotNode.position = CGPoint(x: size.width * 0.6, y: 70)
            robotNode.setScale(1.5)
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
        let translation  = recognizer.translationInView(self.view!)
        let velocity = recognizer.velocityInView(self.view!)

        switch recognizer.state {
        case .Began:
            cameraNode.removeActionForKey("scroll")
        case .Changed:
            if (view as! GameView).verticalPan {
                cameraNode.position.y += translation.y * 667 / self.view!.frame.height
            } else {
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
            }
        case .Ended:
            if (view as! GameView).verticalPan {
                let acceleration = CGFloat(-10000.0)
                var scrollDuration = CGFloat(0.8)
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
            if CGRectContainsPoint(CGRect(x: nextExperimentNode!.position.x - 30, y: nextExperimentNode!.position.y - 30, width: 60, height: 60), positionInScene) {
                let experience = play(experimentNodes[nextExperimentNode!.experiment.number]!)
                playExperience = true
                animNextExperiment(experience, nextClock: nextExperimentClock + 1)
                handlingTap = true
            }
        }
        
        if !playExperience {
            for (clock, eventNode) in eventNodes {
                if eventNode.containsPoint(positionInScene) {
                    eventNode.runPressAction()
                    let experience = play(experimentNodes[eventNode.experienceNode.experience.experiment.number]!)
                    animNextExperiment(experience, nextClock: clock + 1)
                    handlingTap = true
                }
            }
        }
        if CGRectContainsPoint(robotNode.imageNode.frame, positionInRobot) {
            robotNode.imageNode.runAction(actionPress)
            robotNode.toggleButton()
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
    
    
    override func longPress(recognizer: UILongPressGestureRecognizer)
    {
        let positionInScene = self.convertPointFromView(recognizer.locationInView(self.view))
        let positionInShapePopup = shapePopupNode.convertPoint(positionInScene, fromNode: self)
        let positionInColorPopup = colorPopupNode.convertPoint(positionInScene, fromNode: self)

        switch recognizer.state {
        case .Began:
            for experimentNode in experimentNodes.values {
                if CGRectContainsPoint(experimentNode.frame, positionInScene) {
                    let shapeNodeIndex = experimentNode.experiment.shapeIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveShapes), userInfo: nil, repeats: true)
                    editNode = experimentNode
                    //shapeNodes.forEach({$0.lineWidth = 3})
                    //shapeNodes[shapeNodeIndex].lineWidth = 6
                    //addChild(shapePopupNode!)
                    shapePopupNode.position = experimentNode.position
                    shapePopupNode.update(shapeNodeIndex)
                    shapePopupNode.appear()
                }
            }
            for eventNode in eventNodes.values {
                if CGRectContainsPoint(eventNode.calculateAccumulatedFrame(), positionInScene) {
                    let colorIndex = eventNode.experienceNode.experience.colorIndex
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameSKScene.revolveColors), userInfo: nil, repeats: true)
                    editNode = eventNode
                    //colorPopupNode = gameModel.createColorPopup()
                    let pathFunc = gameModel.experimentPaths[eventNode.experienceNode.experience.experiment.shapeIndex]
                    colorPopupNode.createColorNodes(pathFunc, experienceColors: gameModel.experienceColors, colorIndex: colorIndex)
                    
                    //colorNodes = gameModel.createColorNodes(colorPopupNode!, experience: eventNode.experienceNode.experience)
                    //colorNodes.forEach({$0.lineWidth = 1})
                    //cameraRelativeOriginNode.addChild(colorPopupNode!)
                    colorPopupNode.position = self.convertPoint(eventNode.position, toNode: cameraRelativeOriginNode)
                    colorPopupNode.appear()
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
            //shapePopupNode.removeFromParent()
            if let experimentNode = editNode as? ExperimentSKNode {
                shapePopupNode.disappear(experimentNode.position)
            }
            selectColorNode(positionInColorPopup)
            //colorNodes = Array<SKShapeNode>()
            //colorPopupNode?.removeFromParent()
            //colorPopupNode = nil
            if let eventNode = editNode as? EventSKNode{
                colorPopupNode.disappear(self.convertPoint(eventNode.position, toNode: cameraRelativeOriginNode))
                eventNode.frameNode.hidden  = true
            }
            editNode = nil
        default:
            break
        }
    }
    
    func doubleTap(gesture:UITapGestureRecognizer) {
        // The doubeTapGesture is disabled if the tapGesture handles the tap.
        let actionScrollToOrigin = SKAction.moveBy(CGVector(dx: 0.0, dy: 233 - cameraNode.position.y), duration: NSTimeInterval( cameraNode.position.y / 2000))
        actionScrollToOrigin.timingMode = .EaseInEaseOut
        cameraNode.runAction(actionScrollToOrigin)
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
                robotNode.gameCenterButtonNode.activate()
            }
            if robotNode.recommendation == RECOMMEND.INSTRUCTION_OK {
                robotNode.recommend(RECOMMEND.IMAGINE)
            }
        }
        scoreNode.updateScore(score, clock: clock, winMoves: winMoves)
        robotNode.animRobot(experience.valence)
        
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
    
    func selectShapeNode(positionInShapePopup: CGPoint?) {
        for i in 0..<shapePopupNode.shapeNodes.count {
            if CGRectContainsPoint(shapePopupNode.shapeNodes[i].frame, positionInShapePopup!) {
                shapePopupNode.shapeNodes.forEach({$0.lineWidth = 3})
                shapePopupNode.shapeNodes[i].lineWidth = 6
                reshapeNodes(i)
            }
        }
    }
    func selectColorNode(positionInColorPopup: CGPoint?) {
        for i in 0..<colorPopupNode.colorNodes.count {
            if CGRectContainsPoint(colorPopupNode.colorNodes[i].frame, positionInColorPopup!) {
                colorPopupNode.colorNodes.forEach({$0.lineWidth = 1})
                colorPopupNode.colorNodes[i].lineWidth = 6
                refillNodes(i)
            }
        }
    }
    
    func revolveShapes() {
/*        shapeNodes[shapeNodeIndex].lineWidth = 3
        shapeNodeIndex += 1
        if shapeNodeIndex >= shapeNodes.count {
            shapeNodeIndex = 0
        }
        shapeNodes[shapeNodeIndex].lineWidth = 6
 */
        shapePopupNode.revolve()
        reshapeNodes(shapePopupNode.shapeIndex)
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
        colorPopupNode.revolve()
        refillNodes(colorPopupNode.colorIndex)
    }

    func refillNodes(colorIndex: Int) {
        if let eventNode = editNode as? EventSKNode {
            eventNode.experienceNode.experience.colorIndex = colorIndex
            for node in eventNodes.values {
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

