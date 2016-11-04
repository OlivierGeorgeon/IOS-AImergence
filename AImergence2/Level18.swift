//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  Copyright (c) 2015 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameplayKit

class Level18 : Level5 {
    
    override var number:Int { return 18 }
    override var gameModelString: String { return "GameModel18" }
    
    var phenomenonLeft  = false
    var phenomenonRight = false

    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 5) // feel left
        let experiment1 = Experiment(number: 1, shapeIndex: 1) // flip left
        let experiment2 = Experiment(number: 2, shapeIndex: 6) // feel both
        let experiment3 = Experiment(number: 3, shapeIndex: 7) // feel right
        let experiment4 = Experiment(number: 4, shapeIndex: 3) // flip right
        
        let experiments = [experiment0, experiment1, experiment2, experiment3, experiment4]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence: 0, colorIndex: 1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 0, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence: 0, colorIndex: 4)
        let experience22 = Experience(experiment: experiment2, resultNumber: 2, valence: 10, colorIndex: 1)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence: 0, colorIndex: 1)
        let experience40 = Experience(experiment: experiment4, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience41 = Experience(experiment: experiment4, resultNumber: 1, valence: 0, colorIndex: 1)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21, experience22], [experience30, experience31], [experience40, experience41]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
    }
    
    override func play(_ experiment: Experiment) -> (Experience, Int) {
        
        var result = 0
        
        switch experiment.number {
        case 0: // feel left
            if phenomenonLeft { result = 1 }
        case 1: // swap left
            phenomenonLeft = !phenomenonLeft
            if phenomenonLeft { result = 1 }
        case 2: // feel both
            if phenomenonLeft != phenomenonRight { result = 1 }
            if phenomenonLeft && phenomenonRight { result = 2 }
        case 3: // feel right
            if phenomenonRight { result = 1 }
        case 4: // swap right
            phenomenonRight = !phenomenonRight
            if phenomenonRight { result = 1 }
        default:
            break
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }

}
