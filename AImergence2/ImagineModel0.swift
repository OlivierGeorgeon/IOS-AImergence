//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel0
{    
    let actionLiftExperience = SCNAction.moveByX( 0.0, y: 5.0 * 10, z: 0.0, duration: 3.0)
    
    let gameModel: GameModel2
    let actions = Actions()
    let scale = Float(10)
    var worldNode = SCNNode()
    var bodyNode: SCNFlippableNode!
    
    var robotNode: SCNRobotNode!
    var constraint: SCNLookAtConstraint!
    let tileYOffset = SCNVector3(0, -5, 0)

    required init(gameModel: GameModel2) {
        self.gameModel = gameModel
    }

    func setup(scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        worldNode.addChildNode(robotNode)
    }
    
    func lightsAndCameras(scene: SCNScene)
    {
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
        //cameraNodes.append(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
        
        //let originNode = SCNNode()
        //scene.rootNode.addChildNode(originNode)
        //let constraint = SCNLookAtConstraint(target: originNode)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints = [constraint]
    }

    func playExperience(experience: Experience) {
        switch experience.experiment.number {
        case 1:
            robotNode.bump()
            spawnExperienceNode(experience, position: robotNode.position + robotNode.forwardVector(), delay: 0.1)
        default:
            robotNode.bumpBack()
            if robotNode.knownCells.updateValue(Phenomenon.TILE, forKey: robotNode.robot.cellBack()) == nil  {
                createTileNode(robotNode.positionCell(robotNode.robot.cellBack()) + SCNVector3(-0.5 * scale, -0.5 * scale, 0), delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()) + tileYOffset, delay: 0.1)
        }
    }
    
    func createTileNode(position: SCNVector3, delay: NSTimeInterval) -> SCNNode {
        let node = SCNNode(geometry: Geometries.tile())
        node.position = position
        node.hidden = true
        worldNode.addChildNode(node)
        let actionWait = SCNAction.waitForDuration(delay)
        node.runAction(SCNAction.sequence([actionWait, SCNAction.waitForDuration(0.1), SCNAction.unhide()]))
        return node
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