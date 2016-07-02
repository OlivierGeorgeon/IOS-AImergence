//
//  RobotController.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation

enum Compass: Int { case EAST, NORTH, WEST, SOUTH }

func ==(lhs: Cell, rhs: Cell) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Cell: Hashable {
    var i:Int
    var j:Int
    var hashValue: Int {return i * 1000 + j}
    init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }
}

class Robot {

    var cell: Cell
    var direction: Compass

    init(i: Int, j: Int, direction: Compass){
        self.cell = Cell(i: i, j: j)
        self.direction = direction
    }
    
    convenience init() {
        self.init(i: 1, j: 1, direction: Compass.EAST)
    }
 
    func turnLeft() {
        switch direction {
        case .EAST, .NORTH, .WEST:
            direction = Compass(rawValue: direction.rawValue + 1)!
        case .SOUTH:
            direction = Compass.EAST
        }
    }
        
    func turnRight() {
        switch direction {
        case .NORTH, .WEST, .SOUTH:
            direction = Compass(rawValue: direction.rawValue - 1)!
        case .EAST:
            direction = Compass.SOUTH
        }
    }
    
    func moveForward() {
        switch direction {
        case .EAST:
            cell.i  += 1
        case .NORTH:
            cell.j  += 1
        case .WEST:
            cell.i  -= 1
        case .SOUTH:
            cell.j  -= 1
        }
    }
    
    func moveBackward() {
        switch direction {
        case .EAST:
            cell.i  -= 1
        case .NORTH:
            cell.j  -= 1
        case .WEST:
            cell.i  += 1
        case .SOUTH:
            cell.j  += 1
        }
    }
    
    func cellFront() -> Cell {
        switch direction {
        case .EAST:
            return Cell(i: cell.i + 1, j: cell.j)
        case .NORTH:
            return Cell(i: cell.i, j: cell.j + 1)
        case .WEST:
            return Cell(i: cell.i - 1, j: cell.j)
        case .SOUTH:
            return Cell(i: cell.i, j: cell.j - 1)
        }
    }
    func cellBack() -> Cell {
        switch direction {
        case .EAST:
            return Cell(i: cell.i - 1, j: cell.j)
        case .NORTH:
            return Cell(i: cell.i, j: cell.j - 1)
        case .WEST:
            return Cell(i: cell.i + 1, j: cell.j)
        case .SOUTH:
            return Cell(i: cell.i, j: cell.j + 1)
        }
    }
    func cellLeft() -> Cell {
        switch direction {
        case .EAST:
            return Cell(i: cell.i, j: cell.j + 1)
        case .NORTH:
            return Cell(i: cell.i - 1, j: cell.j)
        case .WEST:
            return Cell(i: cell.i, j: cell.j - 1)
        case .SOUTH:
            return Cell(i: cell.i + 1, j: cell.j)
        }
    }
    func cellRight() -> Cell {
        switch direction {
        case .EAST:
            return Cell(i: cell.i, j: cell.j - 1)
        case .NORTH:
            return Cell(i: cell.i + 1, j: cell.j)
        case .WEST:
            return Cell(i: cell.i, j: cell.j + 1)
        case .SOUTH:
            return Cell(i: cell.i - 1, j: cell.j)
        }
    }
}