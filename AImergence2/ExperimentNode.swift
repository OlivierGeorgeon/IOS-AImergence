//
//  ExperimentNode.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 20/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit

class ExperimentNode: ReshapableNode
{
    let experiment: Experiment
    let experimentStruct:ExperimentStruct

    override var rect:CGRect {return experimentStruct.rect}
    override var shapeIndex:Int {return experiment.shapeIndex }
    
    init(experiment:Experiment, experimentStruct:ExperimentStruct){
        self.experiment = experiment
        self.experimentStruct = experimentStruct
        super.init()
        reshape()
        fillColor = experimentStruct.color
        lineWidth = 0
        name = "experiment_\(experiment.number)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}