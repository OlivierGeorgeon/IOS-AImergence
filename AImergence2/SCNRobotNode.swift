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
    
    var robot = Robot()
        
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
    
    func positionForward() -> SCNVector3 {
        return SCNVector3(robot.pxForward(), robot.pyForward(), 0)
    }

    func forwardVector() -> SCNVector3 {
        switch robot.direction {
        case .EAST:
            return SCNVector3(1.0, 0.0, 0.0)
        case .NORTH:
            return SCNVector3(0.0, 0.0, -1.0)
        case .WEST:
            return SCNVector3(-1.0, 0.0, 0.0)
        case .SOUTH:
            return SCNVector3(0.0, 0.0, 1.0)
        }
    }
}

func / (left: SCNVector3, right: Int) -> SCNVector3 {
    return SCNVector3(left.x / Float(right), left.y / Float(right), left.z / Float(right)) }

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z) }

prefix func - (vector: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: -vector.x, y: -vector.y, z: -vector.z)}



