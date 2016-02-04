//
//  Experiment.swift
//  AImergence
//
//  Created by Olivier Georgeon on 03/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

func ==(lhs: Experiment, rhs: Experiment) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Experiment : Hashable
{
    var number:Int
    var hashValue: Int {return number}
    
    var shapeIndex = 0
    
    init(number: Int){
        self.number = number
    }    
}
