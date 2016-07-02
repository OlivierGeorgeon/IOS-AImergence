//
//  SCNRobotNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

enum Phenomenon: Int { case NONE, TILE}

class SCNRobotNode: SCNNode {
    
    let bendFront = SCNAction.rotateByX( CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendBack  = SCNAction.rotateByX(-CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendLeft  = SCNAction.rotateByX(0, y: 0, z:  CGFloat(M_PI) / 2, duration: 0.2)
    let bendRight = SCNAction.rotateByX(0, y: 0, z: -CGFloat(M_PI) / 2, duration: 0.2)
    let actionUp = SCNAction.moveBy(SCNVector3(0, 7, 0), duration: 0.1)
    let actionDown = SCNAction.moveBy(SCNVector3(0, -7, 0), duration: 0.1)
    
    let robot = Robot(i: 0, j: 0, direction: Compass.EAST)
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
        
        let robotScene = SCNScene(named: "art.scnassets/Robot8aaNew2.dae")!
        let bodyNodeArray = robotScene.rootNode.childNodes
        for childNode in bodyNodeArray {
            bodyNode.addChildNode(childNode as SCNNode)
        }
        bodyNode.name = "body"
        addChildNode(bodyNode)
        
        pivot = SCNMatrix4MakeRotation(Float(-M_PI/2), 0, 1, 0)
        scale = SCNVector3(3 , 3, 3)

        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(0.0, 15, -15)
        bodyCamera.runAction(SCNAction.rotateByX(-0.7, y: CGFloat(M_PI), z: 0, duration: 0))
        addChildNode(bodyCamera)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func appearRight() {
        self.runAction(SCNAction.sequence([SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) / 2, z: 0.0, duration: 0), SCNAction.unhide()]))
        robot.turnRight()
    }
    
    func turnLeft(duration: NSTimeInterval = 0.2){
        self.runAction(SCNAction.rotateByX(0.0, y: CGFloat(M_PI) / 2, z: 0.0, duration: duration))
        robot.turnLeft()
    }
    
    func turnRight(duration: NSTimeInterval = 0.2) {
        self.runAction(SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) / 2, z: 0.0, duration: duration))
        robot.turnRight()
    }
    
    func moveForward() {
        self.runAction(SCNAction.moveBy(forwardVector(), duration: 0.2))
        robot.moveForward()
    }
    
    func moveBackward() {
        self.runAction(SCNAction.moveBy(-forwardVector(), duration: 0.2))
        robot.moveBackward()
    }
    
    func bump() {
        let moveHalfFront = SCNAction.moveBy(forwardVector() / 2, duration: 0.1)
        let moveHalfBack  = SCNAction.moveBy(-forwardVector() / 2, duration: 0.1)
        self.runAction(SCNAction.sequence([moveHalfFront, moveHalfBack]))
    }
    
    func bumpBack() {
        let moveHalfBack  = SCNAction.moveBy(-forwardVector() / 2, duration: 0.1)
        let moveHalfFront = SCNAction.moveBy(forwardVector() / 2, duration: 0.1)
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
    
    func turnOver(duration: NSTimeInterval = 0.3) {
        self.runAction(SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) , z: 0.0, duration: duration))
        robot.turnRight()
        robot.turnRight()
    }
    
    func feelLeftAndTurnOver(duration: NSTimeInterval = 0.3) {
        feelLeft()
        let turnOver = SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) , z: 0.0, duration: duration)
        self.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.2), turnOver]))
        robot.turnRight()
        robot.turnRight()
    }
    
    func feelRightAndTurnOver(duration: NSTimeInterval = 0.3) {
        feelRight()
        let turnOver = SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) , z: 0.0, duration: duration)
        self.runAction(SCNAction.sequence([SCNAction.waitForDuration(0.2), turnOver]))
        robot.turnRight()
        robot.turnRight()
    }
    
    func jumpi() {
        print("jumpi")
        self.runAction(SCNAction.sequence([actionUp, actionDown]))
    }
    
    func positionCell(cell: Cell) -> SCNVector3 {
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
        case .EAST:
            return SCNVector3(1.0 * 10, 0.0, 0.0)
        case .NORTH:
            return SCNVector3(0.0, 0.0, -1.0 * 10)
        case .WEST:
            return SCNVector3(-1.0 * 10, 0.0, 0.0)
        case .SOUTH:
            return SCNVector3(0.0, 0.0, 1.0 * 10)
        }
    }
}

func / (left: SCNVector3, right: Int) -> SCNVector3 {
    return SCNVector3(left.x / Float(right), left.y / Float(right), left.z / Float(right)) }

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z) }

prefix func - (vector: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: -vector.x, y: -vector.y, z: -vector.z)}



