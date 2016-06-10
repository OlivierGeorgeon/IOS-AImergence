//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level16 : Level15 {
    
    override var number:Int { return 16 }
    override var gameModelString: String { return "GameModel6"}
    
    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 1)
        let experiment1 = Experiment(number: 1, shapeIndex: 4)
        let experiment2 = Experiment(number: 2, shapeIndex: 3)
        let experiment3 = Experiment(number: 3, shapeIndex: 6)
        let experiment4 = Experiment(number: 4, shapeIndex: 5)
        let experiment5 = Experiment(number: 5, shapeIndex: 7)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1, experiment2, experiment3, experiment4, experiment5]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-2)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-4, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 4, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-2)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence:-1)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence:-1)
        let experience40 = Experience(experiment: experiment4, resultNumber: 0, valence:-1)
        let experience41 = Experience(experiment: experiment4, resultNumber: 1, valence:-1)
        let experience50 = Experience(experiment: experiment5, resultNumber: 0, valence:-1)
        let experience51 = Experience(experiment: experiment5, resultNumber: 1, valence:-1)
        let experiences = [[experience00], [experience10, experience11], [experience20], [experience30, experience31], [experience40, experience41], [experience50, experience51]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
        robot.cell = Cell(i: 2, j: 1)
    }    
}