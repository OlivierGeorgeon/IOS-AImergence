//
//  RobotController.swift
//  Little AI
//
//  Created by Olivier Georgeon on 20/05/16.
//  CC0 No rights reserved.
//

import Foundation

enum Compass: Int { case east, north, west, south }

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
        self.init(i: 1, j: 1, direction: Compass.east)
    }
 
    func turnLeft() {
        switch direction {
        case .east, .north, .west:
            direction = Compass(rawValue: direction.rawValue + 1)!
        case .south:
            direction = Compass.east
        }
    }
        
    func turnRight() {
        switch direction {
        case .north, .west, .south:
            direction = Compass(rawValue: direction.rawValue - 1)!
        case .east:
            direction = Compass.south
        }
    }
    
    func moveForward() {
        switch direction {
        case .east:
            cell.i  += 1
        case .north:
            cell.j  += 1
        case .west:
            cell.i  -= 1
        case .south:
            cell.j  -= 1
        }
    }
    
    func moveBackward() {
        switch direction {
        case .east:
            cell.i  -= 1
        case .north:
            cell.j  -= 1
        case .west:
            cell.i  += 1
        case .south:
            cell.j  += 1
        }
    }
    
    func cellFront() -> Cell {
        switch direction {
        case .east:
            return Cell(i: cell.i + 1, j: cell.j)
        case .north:
            return Cell(i: cell.i, j: cell.j + 1)
        case .west:
            return Cell(i: cell.i - 1, j: cell.j)
        case .south:
            return Cell(i: cell.i, j: cell.j - 1)
        }
    }
    func cellBack() -> Cell {
        switch direction {
        case .east:
            return Cell(i: cell.i - 1, j: cell.j)
        case .north:
            return Cell(i: cell.i, j: cell.j - 1)
        case .west:
            return Cell(i: cell.i + 1, j: cell.j)
        case .south:
            return Cell(i: cell.i, j: cell.j + 1)
        }
    }
    func cellLeft() -> Cell {
        switch direction {
        case .east:
            return Cell(i: cell.i, j: cell.j + 1)
        case .north:
            return Cell(i: cell.i - 1, j: cell.j)
        case .west:
            return Cell(i: cell.i, j: cell.j - 1)
        case .south:
            return Cell(i: cell.i + 1, j: cell.j)
        }
    }
    func cellRight() -> Cell {
        switch direction {
        case .east:
            return Cell(i: cell.i, j: cell.j - 1)
        case .north:
            return Cell(i: cell.i + 1, j: cell.j)
        case .west:
            return Cell(i: cell.i, j: cell.j + 1)
        case .south:
            return Cell(i: cell.i - 1, j: cell.j)
        }
    }
}
