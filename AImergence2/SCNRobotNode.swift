//
//  SCNRobotNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

enum Phenomenon: Int { case none, tile}

class SCNRobotNode: SCNNode {
    
    let bendFront = SCNAction.rotateBy( x: CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendBack  = SCNAction.rotateBy(x: -CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendLeft  = SCNAction.rotateBy(x: 0, y: 0, z:  CGFloat(M_PI) / 2, duration: 0.2)
    let bendRight = SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat(M_PI) / 2, duration: 0.2)
    let actionUp = SCNAction.move(by: SCNVector3(0, 7, 0), duration: 0.1)
    let actionDown = SCNAction.move(by: SCNVector3(0, -7, 0), duration: 0.1)
    let actionTurnLeft = SCNAction.rotateBy(x: 0.0, y: CGFloat(M_PI) / 2, z: 0.0, duration: 0.2)
    let actionTurnRight = SCNAction.rotateBy(x: 0.0, y: -CGFloat(M_PI) / 2, z: 0.0, duration: 0.2)
    let actionTurnOver = SCNAction.rotateBy(x: 0, y: -CGFloat(M_PI) , z: 0, duration: 0.3)
    let turn45Left = SCNAction.rotateBy(x: 0.0, y: CGFloat(M_PI) / 4, z: 0.0, duration: 0.2)
    let turn45Right = SCNAction.rotateBy(x: 0.0, y: -CGFloat(M_PI) / 4, z: 0.0, duration: 0.2)
    let turn45Left1 = SCNAction.rotateBy(x: 0.0, y: CGFloat(M_PI) / 4, z: 0.0, duration: 0.1)
    let turn45Right1 = SCNAction.rotateBy(x: 0.0, y: -CGFloat(M_PI) / 4, z: 0.0, duration: 0.1)
    
    let robot = Robot(i: 0, j: 0, direction: Compass.east)
    var knownCells = [Cell: Phenomenon]()
    
    let bodyNode = SCNNode()
    let bodyCamera = SCNNode()
    
    override init() {
        
        super.init()
        
        let robotBaseNode = SCNNode()
        let caterpillarScene = SCNScene(named: "art.scnassets/ChenillesSeulesLarges.dae")!
        let baseNodeArray = caterpillarScene.rootNode.childNodes
        for childNode in baseNodeArray {
            robotBaseNode.addChildNode(childNode as SCNNode)
        }
        addChildNode(robotBaseNode.flattenedClone())
        //addChildNode(robotBaseNode)
        
        let robotScene = SCNScene(named: "art.scnassets/Robot8aaNew.dae")!
        let bodyNodeArray = robotScene.rootNode.childNodes
        for childNode in bodyNodeArray {
            bodyNode.addChildNode(childNode as SCNNode)
        }
        bodyNode.name = "body"
        addChildNode(bodyNode)
        
        pivot = SCNMatrix4MakeRotation(Float(-M_PI/2), 0, 1, 0)
        scale = SCNVector3(3 , 3, 3)
        
        bendFront.timingMode = .easeInEaseOut
        bendBack.timingMode = .easeInEaseOut
        bendRight.timingMode = .easeInEaseOut
        bendLeft.timingMode = .easeInEaseOut
        actionUp.timingMode = .easeOut
        actionDown.timingMode = .easeIn
        actionTurnLeft.timingMode = .easeInEaseOut
        actionTurnRight.timingMode = .easeInEaseOut
        actionTurnOver.timingMode = .easeInEaseOut
        turn45Left.timingMode = .easeInEaseOut
        turn45Right.timingMode = .easeInEaseOut

        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(0.0, 15, -15)
        bodyCamera.runAction(SCNAction.rotateBy(x: -0.7, y: CGFloat(M_PI), z: 0, duration: 0))
        addChildNode(bodyCamera)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func appearRight() {
        self.runAction(SCNAction.sequence([SCNAction.rotateBy(x: 0.0, y: -CGFloat(M_PI) / 2, z: 0.0, duration: 0), SCNAction.unhide()]))
        robot.turnRight()
    }
    
    func turnLeft(){
        self.runAction(actionTurnLeft)
        robot.turnLeft()
    }
    
    func turnRight() {
        self.runAction(actionTurnRight)
        robot.turnRight()
    }
    
    func moveForward() {
        let actionForward = SCNAction.move(by: forwardVector(), duration: 0.2)
        actionForward.timingMode = .easeInEaseOut
        self.runAction(actionForward)
        robot.moveForward()
    }
    
    func moveBackward() {
        let actionBackward = SCNAction.move(by: -forwardVector(), duration: 0.2)
        actionBackward.timingMode = .easeInEaseOut
        self.runAction(actionBackward)
        robot.moveBackward()
    }
    
    func bump() {
        let moveHalfFront = SCNAction.move(by: forwardVector() / 2, duration: 0.1)
        moveHalfFront.timingMode = .easeIn
        let moveHalfBack  = SCNAction.move(by: -forwardVector() / 2, duration: 0.1)
        moveHalfBack.timingMode = .easeOut
        self.runAction(SCNAction.sequence([moveHalfFront, moveHalfBack]))
    }
    
    func bumpBack() {
        let moveHalfBack  = SCNAction.move(by: -forwardVector() / 2, duration: 0.1)
        moveHalfBack.timingMode = .easeIn
        let moveHalfFront = SCNAction.move(by: forwardVector() / 2, duration: 0.1)
        moveHalfFront.timingMode = .easeOut
        self.runAction(SCNAction.sequence([moveHalfBack, moveHalfFront]))
    }
    
    func feelFront() {
        bodyNode.runAction(SCNAction.sequence([bendFront, bendBack]))
    }
    
    func feelLeft() {
        bodyNode.runAction(SCNAction.sequence([bendRight, bendLeft]))
    }
    
    func feelRight() {
        bodyNode.runAction(SCNAction.sequence([bendLeft, bendRight]))
    }
    
    func feelFrontLeft() {
        self.runAction(SCNAction.sequence([turn45Left, turn45Right]))
        bodyNode.runAction(SCNAction.sequence([bendFront, bendBack]))
        //bodyNode.runAction(SCNAction.sequence([SCNAction.group([turn45Left, bendFront]), SCNAction.group([turn45Right, bendBack])]))
    }
    
    func feelFrontRight() {
        self.runAction(SCNAction.sequence([turn45Right, turn45Left]))
        bodyNode.runAction(SCNAction.sequence([bendFront, bendBack]))
        //bodyNode.runAction(SCNAction.sequence([SCNAction.group([turn45Right, bendFront]), SCNAction.group([turn45Left, bendBack])]))
    }
    
    func turnOver() {
        self.runAction(actionTurnOver)
        robot.turnRight()
        robot.turnRight()
    }

    func jump() {
        self.runAction(SCNAction.sequence([actionUp, actionDown]))
    }
    
    func jumpLeft() {
        self.runAction(SCNAction.sequence([turn45Left1, actionUp, actionDown, turn45Right1]))
    }
    
    func jumpRight() {
        self.runAction(SCNAction.sequence([turn45Right1, actionUp, actionDown, turn45Left1]))
    }

    func positionCell(_ cell: Cell) -> SCNVector3 {
        return SCNVector3(cell.i * 10, 0, -cell.j * 10)
    }
    
    func positionForward() -> SCNVector3 {
        return SCNVector3(robot.cellFront().i * 10, 0, -robot.cellFront().j * 10)
    }

    func positionBack() -> SCNVector3 {
        return SCNVector3(robot.cellBack().i * 10, 0, -robot.cellBack().j * 10)
    }
    
    func positionLeft() -> SCNVector3 {
        return SCNVector3(robot.cellLeft().i * 10, 0, -robot.cellLeft().j * 10)
    }
    
    func positionRight() -> SCNVector3 {
        return SCNVector3(robot.cellRight().i * 10, 0, -robot.cellRight().j * 10)
    }
    
    func forwardVector() -> SCNVector3 {
        switch robot.direction {
        case .east:
            return SCNVector3(10, 0, 0)
        case .north:
            return SCNVector3(0, 0, -10)
        case .west:
            return SCNVector3(-10, 0, 0)
        case .south:
            return SCNVector3(0, 0, 10)
        }
    }
}

func / (left: SCNVector3, right: Int) -> SCNVector3 {
    return SCNVector3(left.x / Float(right), left.y / Float(right), left.z / Float(right)) }

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z) }

prefix func - (vector: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: -vector.x, y: -vector.y, z: -vector.z)}



