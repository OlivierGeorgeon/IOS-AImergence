//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level015 : Level014 {
    
    override var number:Int { return 15 }
    override var gameModelString: String { return "GameModel15"}
    
    override var board: [[Int]] { return [[1, 1, 1, 1, 1, 1],
                                          [1, 0, 0, 0, 0, 1],
                                          [1, 0, 1, 1, 0, 1],
                                          [1, 0, 1, 0, 0, 1],
                                          [1, 0, 0, 0, 1, 1],
                                          [1, 1, 1, 1, 1, 1]] }
    
    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 1)
        let experiment1 = Experiment(number: 1, shapeIndex: 4)
        let experiment2 = Experiment(number: 2, shapeIndex: 3)
        let experiment3 = Experiment(number: 3, shapeIndex: 6)
        let experiment4 = Experiment(number: 4, shapeIndex: 5)
        let experiment5 = Experiment(number: 5, shapeIndex: 7)
        
        let experiments = [experiment0, experiment1, experiment2, experiment4, experiment3, experiment5]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-4)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-10, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 4, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-4)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence:0, colorIndex: 1)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence:0, colorIndex: 2)
        let experience40 = Experience(experiment: experiment4, resultNumber: 0, valence:0, colorIndex: 1)
        let experience41 = Experience(experiment: experiment4, resultNumber: 1, valence:0, colorIndex: 2)
        let experience50 = Experience(experiment: experiment5, resultNumber: 0, valence:0, colorIndex: 1)
        let experience51 = Experience(experiment: experiment5, resultNumber: 1, valence:0, colorIndex: 2)
        let experiences = [[experience00], [experience10, experience11], [experience20], [experience30, experience31], [experience40, experience41], [experience50, experience51]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
        robot.cell = Cell(i: 2, j: 1)
    }
    
    override func play(_ experiment: Experiment) -> (Experience, Int) {
        
        var result = 0
        
        switch experiment.number {
        case 0:
            robot.turnLeft()
        case 1:
            if board[robot.cellFront().i][robot.cellFront().j] == 0 {
                robot.moveForward()
                result = 1
            }
        case 2:
            robot.turnRight()
        case 3:
            result = board[robot.cellFront().i][robot.cellFront().j]
        case 4:
            result = board[robot.cellLeft().i][robot.cellLeft().j]
        default:
            result = board[robot.cellRight().i][robot.cellRight().j]
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}
