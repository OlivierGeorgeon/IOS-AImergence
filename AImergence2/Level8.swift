//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level8: Level5 {
    
    override var number:Int { return 8 }

    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1, experiment2]) as! [Experiment]

        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:0, colorIndex: 0)//2)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence:0, colorIndex: 0)//1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-10, colorIndex: 0)//2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence:2, colorIndex: 0)//1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:0, colorIndex: 0)//4)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence:0, colorIndex: 0)//4)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21]]

        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }    

    override func play(experiment: Experiment) -> (Experience, Int) {
        
        var result = 0
        
        switch experiment.number {
        case 0: // touch
            if currentPhenomenon { result = 1 }
        case 1: // eat
            if currentPhenomenon { result = 1 }
            currentPhenomenon = nextPhenomenon // (arc4random_uniform(2) == 0)
            nextPhenomenon = !nextPhenomenon
        case 2: //swap
            currentPhenomenon = !currentPhenomenon
        default:
            break
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}