//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  CC0 No rights reserved.
//

import Foundation
import GameplayKit

class Level202 : Level005 {
    
    override var number:Int { return 202 }
    override var gameModelString: String { return "GameModel5" }
    
    var orientation = false
    
    var currentPhenomenon2 = false

    convenience required init() {
        let experiment0 = Experiment(number: 0, shapeIndex: 1)
        let experiment1 = Experiment(number: 1, shapeIndex: 2)
        let experiment2 = Experiment(number: 2, shapeIndex: 0)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1, experiment2]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience01 = Experience(experiment: experiment0, resultNumber: 1, valence: 0, colorIndex: 1)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence: 0, colorIndex: 4)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 1, colorIndex: 1)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence: 0, colorIndex: 2)
        let experience21 = Experience(experiment: experiment2, resultNumber: 1, valence: 0, colorIndex: 1)
        let experiences = [[experience00, experience01], [experience10, experience11], [experience20, experience21]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
    }
    
    override func play(_ experiment: Experiment) -> (Experience, Int) {
        
        var result = 0
        
        switch experiment.number {
        case 0: // touch
            if orientation {
                if currentPhenomenon { result = 1 }
            } else {
                if currentPhenomenon2 { result = 1 }
            }
        case 1: // eat
            orientation = !orientation
            if currentPhenomenon && currentPhenomenon2 {
                result = 1
            }
        case 2: //swap
            if orientation {
                currentPhenomenon = !currentPhenomenon
                if currentPhenomenon { result = 1 }
            } else {
                currentPhenomenon2 = !currentPhenomenon2
                if currentPhenomenon2 { result = 1 }
            }
        default:
            orientation = !orientation
        }
        
        let experience = experiences[experiment.number][result]
        
        return (experience, score(experience))
    }

}
