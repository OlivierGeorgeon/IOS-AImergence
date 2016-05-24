//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level12 : Level11 {
    
    override var number:Int { return 12 }
    
    override var board: [[Int]] { return [[1, 1, 1],
                                          [1, 0, 1],
                                          [1, 0, 1],
                                          [1, 1, 1]] }
    
    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1, experiment2]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-4)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 4)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-1)
        let experiences = [[experience00], [experience10, experience11], [experience20]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }
    
}