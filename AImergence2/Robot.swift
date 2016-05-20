//
//  RobotController.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation

enum compass: Int { case EAST, NORTH, WEST, SOUTH }

class Robot {

    var px: Int
    var py: Int
    var direction: compass

    init(px: Int, py: Int, direction: compass){
        self.px = px
        self.py = py
        self.direction = direction
    }
    
    convenience init() {
        self.init(px: 1, py: 1, direction: compass.EAST)
    }
 
    func turnLeft() {
        switch direction {
        case .EAST, .NORTH, .WEST:
            direction = compass(rawValue: direction.rawValue + 1)!
        case .SOUTH:
            direction = compass.EAST
        }
    }
        
    func turnRight() {
        switch direction {
        case .NORTH, .WEST, .SOUTH:
            direction = compass(rawValue: direction.rawValue - 1)!
        case .EAST:
            direction = compass.SOUTH
        }
    }
    
    func moveForward() {
        switch direction {
        case .EAST:
            px  += 1
        case .NORTH:
            py  += 1
        case .WEST:
            px  -= 1
        case .SOUTH:
            py  -= 1
        }
    }
    
    func pxForward() -> Int {
        switch direction {
        case .EAST:
            return px  + 1
        case .NORTH:
            return px
        case .WEST:
            return px - 1
        case .SOUTH:
            return px
        }
    }

    func pyForward() -> Int {
        switch direction {
        case .EAST:
            return py
        case .NORTH:
            return py + 1
        case .WEST:
            return py
        case .SOUTH:
            return py - 1
        }
    }

}