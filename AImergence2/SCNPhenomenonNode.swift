//
//  SCNPhenomenon.swift
//  Little AI
//
//  Created by Olivier Georgeon on 19/08/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class SCNPhenomenonNode: SCNNode {
    
    init(geometry: SCNGeometry) {
        super.init()
        self.geometry = geometry
        self.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(geometry: SCNGeometry) {
        self.geometry = geometry
    }
}