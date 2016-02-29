//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit


class Level0 {
    
    let winScore:Int
    let historicalDepth:Int
    let experiments:[Experiment]
    let experiences:[[Experience]]
    
    var number:Int { return 0 }
    var valenceTrace:[Int]
    
    var gameModelString: String {
        var gameModelString = "GameModel2"
        if experiments.count > 2 {
            gameModelString = "GameModel3"
        }
        return gameModelString
    }

    init(winScore: Int, historicalDepth: Int, experiments:[Experiment], experiences:[[Experience]]) {
        self.winScore = winScore
        self.historicalDepth = historicalDepth
        self.valenceTrace = [Int](count:historicalDepth, repeatedValue: 0)
        self.experiments = experiments
        self.experiences = experiences
    }
    
    convenience  required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray([experiment0, experiment1]) as! [Experiment]

        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:0)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence:1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:0)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence:1)
        let experiences = [[experience00, experience01], [experience10, experience11]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }
    
    func play(experiment: Experiment) -> (Experience, Int) {
        
        var result:Int
        
        switch experiment.number {
        case 0:
            result = 0
        default:
            result = 1
        }
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
    
    func score(experience: Experience) -> Int {
        valenceTrace.removeAtIndex(0)
        valenceTrace.append(experience.valence)
        return valenceTrace.reduce(0, combine: +)
    }
}