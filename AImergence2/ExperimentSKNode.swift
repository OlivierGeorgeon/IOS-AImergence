//
//  ExperimentNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ExperimentSKNode: ReshapableSKNode
{
    let experiment: Experiment

    override var shapeIndex:Int {return experiment.shapeIndex }
    
    init(rect: CGRect, experiment: Experiment) {
        self.experiment = experiment
        super.init(rect: rect)
    }
    
    convenience init(experiment:Experiment, gameModel:GameModel2){
        self.init(rect: gameModel.experimentRect, experiment: experiment)
        reshape()
        fillColor = gameModel.color
        lineWidth = 0
        name = "experiment_\(experiment.number)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}