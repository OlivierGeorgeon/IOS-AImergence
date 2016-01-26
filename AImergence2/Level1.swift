//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation

class Level1 : Level0 {
    
    override var number:Int { return 1 }
    
    var previousExperiment:Experiment?
    
    override func play(experiment: Experiment) -> (Experience, Int) {
        
        var result:Int
        
        if previousExperiment == experiment {
            result = 0
        } else {
            result = 1
        }
        
        previousExperiment = experiment
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }
}