//
//  WorldPhenomena.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class Geometries
{
    class func defaultExperienceMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        //material.diffuse.contents = UIColor.lightGrayColor()
        //material.diffuse.contents = UIColor(red: 214/256, green: 236/256, blue: 255/256, alpha: 1)
        material.diffuse.contents = UIColor(red: 162/256, green: 191/256, blue: 214/256, alpha: 1)
        material.specular.contents = UIColor.whiteColor()
        //material.specular.contents = UIColor(red: 114/256, green: 114/256, blue: 171/256, alpha: 1)
        return material
    }
    
    class func defaultMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        //material.diffuse.contents = UIColor.lightGrayColor()
        material.diffuse.contents = UIColor(red: 140/256, green: 133/256, blue: 190/256, alpha: 1)
        //material.diffuse.contents = UIColor(red: 185/256, green: 184/256, blue: 239/256, alpha: 1)
        //material.diffuse.contents = UIColor(red: 195/256, green: 198/256, blue: 250/256, alpha: 1)
        material.specular.contents = UIColor.whiteColor()
        //material.specular.contents = UIColor(red: 183/256, green: 137/256, blue: 194/256, alpha: 0.5)
        return material
    }
    
    class func sphere() -> SCNGeometry {
        let geometry = SCNSphere(radius: 0.5 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func cone() -> SCNGeometry {
        let geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.5 , height: 1.0 )
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    class func brick() -> SCNGeometry {
        let geometry = SCNBox(width: 0.5 * 10, height: 1.0 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func tile() -> SCNGeometry {
        let geometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func cube() -> SCNGeometry {
        let geometry = SCNBox(width: 1.0 * 10, height: 1.0 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func capsule() -> SCNGeometry {
        let geometry = SCNCapsule(capRadius: 0.25 * 10, height: 1.0 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    
    class func halfCylinder() -> SCNGeometry {
        let geometry = SCNCylinder(radius: 0.5 * 10, height: 0.5 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }

    class func cylinder() -> SCNGeometry {
        let geometry = SCNCylinder(radius: 0.25 * 10, height: 1.0 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
    class func pyramid() -> SCNGeometry {
        let geometry = SCNPyramid(width: 1.0 * 10, height: 1.0 * 10, length: 1.0 * 10)
        geometry.materials = [defaultMaterial()]
        return geometry
    }
}