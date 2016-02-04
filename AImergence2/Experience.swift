//
//  Experience.swift
//  AImergence
//
//  Created by Olivier Georgeon on 03/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

func ==(lhs: Experience, rhs: Experience) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Experience : Hashable
{
    let experiment: Experiment
    let resultNumber: Int
    let valence: Int
    
    var experimentNumber: Int {return experiment.number}
    var hashValue: Int {assert(resultNumber < 10); return experimentNumber * 10 + resultNumber}

    var shapeIndex: Int {return experiment.shapeIndex}
    var colorIndex = 0
    
    init(experiment: Experiment, resultNumber: Int, valence: Int){
        self.experiment = experiment
        self.resultNumber = resultNumber
        self.valence = valence
    }

    init(experiment: Experiment, resultNumber: Int, valence: Int, colorIndex: Int){
        self.experiment = experiment
        self.resultNumber = resultNumber
        self.valence = valence
        self.colorIndex = colorIndex
    }
}