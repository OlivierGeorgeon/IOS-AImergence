//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import GameplayKit
import Foundation

class Level6 : Level4 {
    
    override var number:Int { return 6 }

    var env = [1, 7, 3, 2, 9, 8, 5, 6, 7, 8, 0]
    var p = 0
    
    convenience init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1, experiment2]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:0)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence:0)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:0)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence:1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:0)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence:0)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }

    override func play(experiment: Experiment) -> (Experience, Int) {
        
        var result = 0
        
        switch experiment.number {
        case 0: // touch
            if env[p] <= env[p + 1] { result = 1 }
        case 1: // eat
            if env[p] <= env[p + 1] { result = 1 }
            if ++p > 6 { p = 0 }
        case 2: // swap
            let temp = env[p]
            env[p] = env[p + 1]
            env[p + 1] = temp
            if env[p] <= env[p + 1] { result = 1 }
        default:
            break
        }
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}