//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level201 : Level200 {
    
    override var number:Int { return 19 }
    
    convenience required init() {
        let experiment0 = Experiment(number: 0) // feel left
        let experiment1 = Experiment(number: 1) // flip left
        let experiment2 = Experiment(number: 2) // feel both
        let experiment3 = Experiment(number: 3) // feel right
        let experiment4 = Experiment(number: 4) // flip right
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1, experiment2, experiment3, experiment4]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence: 0)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence: 0)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence: 0)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 0)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence: 0)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence: 0)
        let experience22 = Experience(experiment: experiment2, resultNumber: 2, valence: 10)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence: 0)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence: 0)
        let experience40 = Experience(experiment: experiment4, resultNumber: 0, valence: 0)
        let experience41 = Experience(experiment: experiment4, resultNumber: 1, valence: 0)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21, experience22], [experience30, experience31], [experience40, experience41]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
    }    
}
