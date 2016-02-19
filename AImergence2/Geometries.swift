//
//  WorldPhenomena.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SceneKit

class Geometries
{
    class func defaultMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.lightGrayColor()
        material.specular.contents = UIColor.whiteColor()
        return material
    }
    
    class func sphere() -> SCNGeometry {
        let geometry = SCNSphere(radius: 0.5)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func cone() -> SCNGeometry {
        let geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.5, height: 1.0)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    class func brick() -> SCNGeometry {
        let geometry = SCNBox(width: 0.5, height: 1.0, length: 1.0, chamferRadius: 0.1)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func cube() -> SCNGeometry {
        let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func capsule() -> SCNGeometry {
        let geometry = SCNCapsule(capRadius: 0.25, height: 1.0)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func halfCylinder() -> SCNGeometry {
        let geometry = SCNCylinder(radius: 0.5, height: 0.5)
        geometry.materials = [defaultMaterial()]
        return geometry
    }

    class func cylinder() -> SCNGeometry {
        let geometry = SCNCylinder(radius: 0.25, height: 1.0)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    class func pyramid() -> SCNGeometry {
        let geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
}