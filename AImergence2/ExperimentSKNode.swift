//
//  ExperimentNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  CC0 No rights reserved.
//

import SpriteKit

class ExperimentSKNode: ReshapableSKNode
{
    let experiment: Experiment

    override var shapeIndex:Int {return experiment.shapeIndex }
    
    init(rect: CGRect, experiment: Experiment, gameModel: GameModel0) {
        self.experiment = experiment
        super.init(rect: rect, gameModel: gameModel)
        reshape()
        fillColor = gameModel.color
        //lineWidth = 0
        name = "experiment_\(experiment.number)"
    }
    
    convenience init(gameModel:GameModel0, experiment:Experiment){
        self.init(rect: gameModel.experimentRect, experiment: experiment, gameModel: gameModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
