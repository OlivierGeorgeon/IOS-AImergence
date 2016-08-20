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
    
    override init() {
        super.init()
    }
    
    convenience init(color: UIColor) {
        self.init()

        let tileGeometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.specular.contents = UIColor.whiteColor()
        tileGeometry.materials = [material]

        self.geometry = tileGeometry
        self.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func colorize(color: UIColor, delay: NSTimeInterval = 0.0) {
        func colorizeBloc(node: SCNNode) {
            node.geometry!.firstMaterial!.diffuse.contents = color
        }
        
        let actionWait = SCNAction.waitForDuration(delay)
        let actionColorize = SCNAction.runBlock(colorizeBloc)
        runAction(SCNAction.sequence([actionWait, actionColorize]))
        //geometry!.firstMaterial!.diffuse.contents = color
    }
    
    func color() -> UIColor {
        if let color = geometry?.firstMaterial?.diffuse.contents as? UIColor {
            return color
        } else {
            return UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        }
    }
}