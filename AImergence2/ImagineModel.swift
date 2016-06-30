//
//  ImagineModel.swift
//  AImergence
//
//  Created by Olivier Georgeon on 19/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel
{
    let actionLiftExperience = SCNAction.moveByX( 0.0, y: 5.0 * 10, z: 0.0, duration: 3.0)

    let gameModel: GameModel2
    let actions = Actions()
    let scale = Float(10)
    var cameraNodes = [SCNNode]()
    var worldNode = SCNNode()
    var bodyNode: SCNNode!

    var robotNode: SCNRobotNode!
    var tiles = [Cell: SCNNode]()
    var constraint: SCNLookAtConstraint!
    let tileYOffset = SCNVector3(0, -4, 0)

    required init(gameModel: GameModel2) {
        self.gameModel = gameModel
    }
    
    func playExperience(experience: Experience) {
    }
    
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
        omniLightNode.position = SCNVector3Make(0, 50 * scale, 50 * scale)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(4 * scale, 1 * scale, 4 * scale)
        cameraNode.runAction(SCNAction.rotateByX(0, y: 0.75, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        cameraNodes.append(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
        
        setupSpecific(scene)
        
        //let originNode = SCNNode()
        //scene.rootNode.addChildNode(originNode)
        //let constraint = SCNLookAtConstraint(target: originNode)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints = [constraint]
    }
    
    func setupSpecific(Scene: SCNScene) {
        
    }
    
    func createPawnNode() -> SCNNode {
        let pawnNode = SCNNode()
        let cylinder = SCNNode(geometry: Geometries.halfCylinder())
        cylinder.position = SCNVector3(0, -0.25 * scale, 0)
        pawnNode.addChildNode(cylinder)
        let sphere = SCNNode(geometry: Geometries.sphere())
        pawnNode.addChildNode(sphere)
        pawnNode.pivot = SCNMatrix4MakeRotation(Float(M_PI/2), 0, 0, 1)
        let pawnNodeFlat = pawnNode.flattenedClone()
        //pawnNodeFlat.addChildNode(createBodyCamera())
        return pawnNodeFlat
    }
    
    func createBodyCamera() -> SCNNode {
        let bodyCamera = SCNNode()
        bodyCamera.camera = SCNCamera()
        //bodyCamera.pivot = SCNMatrix4MakeRotation(Float(-M_PI_2), 1, 1, 1)
        bodyCamera.position = SCNVector3Make(-4.0 * scale, -3.0 * scale , 0.0)
        cameraNodes.append(bodyCamera)
        bodyCamera.runAction(SCNAction.repeatAction(SCNAction.rotateByX(0, y: CGFloat(-M_PI_2), z: CGFloat(M_PI_2 - 0.8), duration: 1), count: 1))
        return bodyCamera
    }
    
    func spawnExperienceNode(experience: Experience, position: SCNVector3, delay:NSTimeInterval = 0.0) {
        let rect = CGRect(x: CGFloat(-2 * scale), y: CGFloat(-2 * scale), width: CGFloat(4 * scale), height: CGFloat(4 * scale))
        let path = gameModel.experimentPaths[experience.experiment.shapeIndex](rect)
        let geometry = SCNShape(path: path, extrusionDepth: CGFloat(1 * scale))
        geometry.materials = [Geometries.defaultExperienceMaterial()]
        if experience.colorIndex > 0 {
            geometry.firstMaterial?.diffuse.contents = gameModel.experienceColors[experience.colorIndex]
        }
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(0.1, 0.1, 0.1)
        experienceNode.position = position
        experienceNode.hidden = true
        worldNode.addChildNode(experienceNode)
        let actionWait = SCNAction.waitForDuration(delay)
        experienceNode.runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionLiftExperience, SCNAction.removeFromParentNode()]))
    }
}