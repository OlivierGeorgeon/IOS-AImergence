//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level013 : Level012 {
    
    override var number:Int { return 13 }
    override var gameModelString: String { return "GameModel13"}
    
    override var board: [[Int]] { return [[1, 1, 1, 1, 1],
                                          [1, 0, 0, 0, 1],
                                          [1, 0, 1, 0, 1],
                                          [1, 0, 0, 0, 1],
                                          [1, 1, 1, 1, 1]] }
    
    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 1)
        let experiment1 = Experiment(number: 1, shapeIndex: 4)
        let experiment2 = Experiment(number: 2, shapeIndex: 3)
        let experiment3 = Experiment(number: 3, shapeIndex: 6)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1, experiment2, experiment3]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-4)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-10, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 4, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-4)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence: 0, colorIndex: 1)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence: 0, colorIndex: 2)
        let experiences = [[experience00], [experience10, experience11], [experience20], [experience30, experience31]]
        
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
        default:
            result = board[robot.cellFront().i][robot.cellFront().j]
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }

}
