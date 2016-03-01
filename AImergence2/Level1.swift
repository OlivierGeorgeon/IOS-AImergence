//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level1 : Level0 {
    
    override var number:Int { return 1 }
    
    var orienationRight = false
    
    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1, experiment2]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-1)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence: 1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-1)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence: 0)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }
    
    override func play(experiment: Experiment) -> (Experience, Int) {
        
        var result:Int
        
        switch (experiment.number, orienationRight) {
        case (0, false):
            result = 1
        case (0, true):
            result = 0
        case (1, false):
            result = 0
        case (1, true):
            result = 1
        case (2, false), (2, true):
            orienationRight = !orienationRight
            result = 0
        default:
            result = 0
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}