//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  CC0 No rights reserved.
//

import Foundation
import GameplayKit

class Level101 : Level100 {
    
    override var number:Int { return 101 }
    override var gameModelString: String { return "GameModel0" }

    var previousExperiment: Experiment?
    var previousRemoteExperimentNumber: Int?

    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 0)
        let experiment1 = Experiment(number: 1, shapeIndex: 1)
        
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
        if previousExperiment != experiment && previousRemoteExperimentNumber != remoteExperimentNumber {
            result = 1
        }
        previousExperiment = experiment
        previousRemoteExperimentNumber = remoteExperimentNumber
        remoteExperimentNumber = nil
        let experience = experiences[experiment.number][result]
        return (experience, score(experience))
    }
}
