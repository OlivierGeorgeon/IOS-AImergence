//
//  WorldPhenomena.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldPhenomena {
    class func sphere() -> SCNGeometry {
        let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        sphere.firstMaterial!.specular.contents = UIColor.whiteColor()
        return sphere
    }
    
    class func cube() -> SCNGeometry {
        let cube = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        cube.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cube.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cube
    }
}