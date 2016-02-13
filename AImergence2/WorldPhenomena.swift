//
//  WorldPhenomena.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class WorldPhenomena
{
    class func sphere() -> SCNGeometry {
        let sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        sphere.firstMaterial!.specular.contents = UIColor.whiteColor()
        return sphere
    }
    
    class func cone() -> SCNGeometry {
        let cone = SCNCone(topRadius: 0.0, bottomRadius: 0.5, height: 1.0)
        cone.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cone.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cone
    }
    class func brick() -> SCNGeometry {
        let cube = SCNBox(width: 0.5, height: 1.0, length: 1.0, chamferRadius: 0.1)
        cube.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cube.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cube
    }
    
    class func cube() -> SCNGeometry {
        let cube = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        cube.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cube.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cube
    }
    
    class func capsule() -> SCNGeometry {
        let capsule = SCNCapsule(capRadius: 0.25, height: 1.0)
        capsule.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        capsule.firstMaterial!.specular.contents = UIColor.whiteColor()
        return capsule
    }
    
    class func halfCylinder() -> SCNGeometry {
        let cylinder = SCNCylinder(radius: 0.5, height: 0.5)
        cylinder.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cylinder.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cylinder
    }

    class func cylinder() -> SCNGeometry {
        let cylinder = SCNCylinder(radius: 0.25, height: 1.0)
        cylinder.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        cylinder.firstMaterial!.specular.contents = UIColor.whiteColor()
        return cylinder
    }
    class func pyramid() -> SCNGeometry {
        let pyramid = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        pyramid.firstMaterial!.diffuse.contents = UIColor.lightGrayColor()
        pyramid.firstMaterial!.specular.contents = UIColor.whiteColor()
        return pyramid
    }
}