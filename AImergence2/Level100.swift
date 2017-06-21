//
//  Level0.swift
//  Little AI
//
//  Created by Olivier Georgeon on 31/12/15.
//  CC0 No rights reserved.
//
//  This is where Level100 is implemented
//  Other levels of Group 1 inherit from this class
//

import Foundation
import GameplayKit

class Level100 : Level005 {
    
    override var number:Int { return 100 }
    override var gameModelString: String { return "GameModel0" }
    override var isMultiPlayer: Bool { return true }

    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence: 1, colorIndex: 1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 1, colorIndex: 1)
        let experiences = [[experience00, experience01], [experience10, experience11]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
    }
    
    override func play(_ experiment: Experiment) -> (Experience, Int) {
        var result = 0
        if experiment.number == remoteExperimentNumber {
            result = 1
        }
        remoteExperimentNumber = nil
        let experience = experiences[experiment.number][result]
        return (experience, score(experience))
    }
}
