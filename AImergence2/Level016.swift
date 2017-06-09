//
//  Level0.swift
//  AImergence
//
//  Created by Olivier Georgeon on 31/12/15.
//  CC0 No rights reserved.
//

import Foundation
import GameplayKit

class Level016 : Level015 {
    
    override var number:Int { return 16 }
    
    convenience required init() {
        let experiment0 = Experiment(number: 0)
        let experiment1 = Experiment(number: 1)
        let experiment2 = Experiment(number: 2)
        let experiment3 = Experiment(number: 3)
        let experiment4 = Experiment(number: 4)
        let experiment5 = Experiment(number: 5)
        
        let experiments = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [experiment0, experiment1, experiment2, experiment3, experiment4, experiment5]) as! [Experiment]
        
        let experience00 = Experience(experiment: experiment0, resultNumber: 0, valence:-4)
        let experience10 = Experience(experiment: experiment1, resultNumber: 0, valence:-10)
        let experience11 = Experience(experiment: experiment1, resultNumber: 1, valence: 4)
        let experience20 = Experience(experiment: experiment2, resultNumber: 0, valence:-4)
        let experience30 = Experience(experiment: experiment3, resultNumber: 0, valence:0)
        let experience31 = Experience(experiment: experiment3, resultNumber: 1, valence:0)
        let experience40 = Experience(experiment: experiment4, resultNumber: 0, valence:0)
        let experience41 = Experience(experiment: experiment4, resultNumber: 1, valence:0)
        let experience50 = Experience(experiment: experiment5, resultNumber: 0, valence:0)
        let experience51 = Experience(experiment: experiment5, resultNumber: 1, valence:0)
        let experiences = [[experience00], [experience10, experience11], [experience20], [experience30, experience31], [experience40, experience41], [experience50, experience51]]
        
        self.init(winScore: 10, historicalDepth: 10, experiments: experiments, experiences: experiences)
        
        robot.cell = Cell(i: 3, j: 3)
    }    
}
