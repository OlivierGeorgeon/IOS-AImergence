//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldScene1 {
    class func allScene() -> SCNNode {
        let allScene = SCNNode()
        
        let sphereNode = SCNNode(geometry: WorldPhenomena.cube())
        allScene.addChildNode(sphereNode)
        
        return allScene
    }
}