//
//  ImagineModel.swift
//  AImergence
//
//  Created by Olivier Georgeon on 19/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel {
    let actions = Actions()
    let scaleExperience = CGFloat(100)
    
    var cameraNodes = [SCNNode]()
    
    var worldNode = SCNNode()
    var bodyNode: SCNNode!

    func setup(scene: SCNScene) {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 1.0, 5.0)
        scene.rootNode.addChildNode(cameraNode)
        cameraNodes.append(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
        
        //let originNode = SCNNode()
        //scene.rootNode.addChildNode(originNode)
        //let constraint = SCNLookAtConstraint(target: originNode)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints = [constraint]
    }
    
    func createPawnNode() -> SCNNode {
        let pawnNode = SCNNode()
        let cylinder = SCNNode(geometry: Geometries.halfCylinder())
        cylinder.position = SCNVector3(0, -0.25, 0)
        pawnNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: Geometries.sphere())
        pawnNode.addChildNode(sphere)
        pawnNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        pawnNode.addChildNode(createBodyCamera())
        return pawnNode.flattenedClone()
    }
    
    func createBodyCamera() -> SCNNode {
        let bodyCamera = SCNNode()
        bodyCamera.camera = SCNCamera()
        bodyCamera.position = SCNVector3Make(-0.0, 0.0, 5.0)
        //bodyCamera.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 1, 0)
        cameraNodes.append(bodyCamera)
        return bodyCamera
    }
    
    func spawnExperienceNode(experience: Experience, position: SCNVector3, delayed:Bool = false) {
        let rect = CGRect(x: -0.2 * scaleExperience, y: -0.2 * scaleExperience, width: 0.4 * scaleExperience, height: 0.4 * scaleExperience)
        let path = ReshapableNode.paths[experience.experiment.shapeIndex](rect)
        let geometry = SCNShape(path: path, extrusionDepth: 0.1 * scaleExperience)
        geometry.materials = [Geometries.defaultMaterial()]
        if experience.colorIndex > 0 {
            geometry.firstMaterial!.diffuse.contents = ExperienceNode.colors[experience.colorIndex]
        }
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(1/scaleExperience, 1/scaleExperience, 1/scaleExperience)
        experienceNode.position = position
        experienceNode.hidden = true
        worldNode.addChildNode(experienceNode)
        if delayed { experienceNode.runAction(actions.waitAndSpawnExperience()) }
        else { experienceNode.runAction(actions.spawnExperience()) }
    }
}