//
//  SCNRobotNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class SCNRobotNode: SCNNode {
    
    let bendFront = SCNAction.rotateByX( CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendBack  = SCNAction.rotateByX(-CGFloat(M_PI) / 2, y: 0, z: 0, duration: 0.2)
    let bendLeft  = SCNAction.rotateByX(0, y: 0, z:  CGFloat(M_PI) / 2, duration: 0.2)
    let bendRight = SCNAction.rotateByX(0, y: 0, z: -CGFloat(M_PI) / 2, duration: 0.2)
    
    let robot = Robot(i: 0, j: 0, direction: Compass.EAST)
    
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
        addChildNode(robotBaseNode)
        
        let robotScene = SCNScene(named: "art.scnassets/Robot8aaNew2.dae")!
        let bodyNodeArray = robotScene.rootNode.childNodes
        for childNode in bodyNodeArray {
            bodyNode.addChildNode(childNode as SCNNode)
        }
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
        
    func turnLeft(){
        self.runAction(SCNAction.rotateByX(0.0, y: CGFloat(M_PI) / 2, z: 0.0, duration: 0.2))
        robot.turnLeft()
    }
    
    func turnRight() {
        self.runAction(SCNAction.rotateByX(0.0, y: -CGFloat(M_PI) / 2, z: 0.0, duration: 0.2))
        robot.turnRight()
    }
    
    func moveForward() {
        self.runAction(SCNAction.moveBy(forwardVector(), duration: 0.2))
        robot.moveForward()
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



