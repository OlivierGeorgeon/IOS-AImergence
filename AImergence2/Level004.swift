//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation

class Level004: Level002 {
    
    override var number:Int { return 4 }
    override var gameModelString: String { return "GameModel4" }
    
    var previousPreviousExperiment:Experiment?
    
    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiments = [experiment0, experiment1]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-1)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence:3)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-1)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence:3)
        let experiences:[[Experience]] = [[experience00, experience01], [experience10, experience11]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }
    
    override func play(_ experiment: Experiment) -> (Experience, Int) {
        
        var result:Int
        
        if previousExperiment == experiment && previousPreviousExperiment != previousExperiment {
            result = 1
        } else {
            result = 0
        }
        
        previousPreviousExperiment = previousExperiment
        previousExperiment = experiment
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}
