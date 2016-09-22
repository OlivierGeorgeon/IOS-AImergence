//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level7: Level5 {
    
    override var number:Int { return 7 }

    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1, experiment2]) as! [Experiment]

        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:0)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence:0)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-10)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence:2)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:0)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence:0)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21]]

        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
    }    
}
