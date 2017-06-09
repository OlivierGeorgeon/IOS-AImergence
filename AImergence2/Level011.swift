//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  CC0 No rights reserved.
//

import Foundation
import GameplayKit

class Level011 : Level000 {
    
    override var number:Int { return 11 }
    override var gameModelString: String { return "GameModel11"}
    
    var board: [[Int]] { return [[1, 1, 1, 1],
                                 [1, 0, 0, 1],
                                 [1, 0, 0, 1],
                                 [1, 1, 1, 1]] }
    
    var robot = Robot()
    
    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 1)
        let experiment1 = Experiment(number: 1, shapeIndex: 4)
        let experiment2 = Experiment(number: 2, shapeIndex: 3)
        
        let experiments = [experiment0, experiment1, experiment2]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-3, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 3, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-1)
        let experiences = [[experience00], [experience10, experience11], [experience20]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
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
        default:
            robot.turnRight()
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}
