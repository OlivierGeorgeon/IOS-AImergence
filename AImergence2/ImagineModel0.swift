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
    let experienceRect = CGRect(x: CGFloat(-20), y: CGFloat(-20), width: CGFloat(40), height: CGFloat(40))
    let tileGeometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
    let blueMaterial = SCNMaterial()
    let gameModel: GameModel0
    let scale = Float(10)
    let worldNode = SCNNode()
    let tileYOffset = SCNVector3(0, -5, 0)

    var bodyNode: SCNFlippableNode!
    var robotNode: SCNRobotNode!
    var constraint: SCNLookAtConstraint!

    required init(gameModel: GameModel0) {
        self.gameModel = gameModel

        blueMaterial.diffuse.contents = UIColor(red: 140/256, green: 133/256, blue: 190/256, alpha: 1)
        blueMaterial.specular.contents = UIColor.whiteColor()
        tileGeometry.materials = [blueMaterial]
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
        let node = SCNNode(geometry: tileGeometry)
        node.position = position
        node.hidden = true
        worldNode.addChildNode(node)
        let actionWait = SCNAction.waitForDuration(delay)
        node.runAction(SCNAction.sequence([actionWait, SCNAction.waitForDuration(0.1), SCNAction.unhide()]))
        return node
    }
    
    func spawnExperienceNode(experience: Experience, position: SCNVector3, delay:NSTimeInterval = 0.0) {
        let path = gameModel.experimentPaths[experience.experiment.shapeIndex](experienceRect)
        let geometry = SCNShape(path: path, extrusionDepth: CGFloat(10))
        let experienceMaterial = SCNMaterial()
        experienceMaterial.specular.contents = UIColor.whiteColor()
        if experience.colorIndex == 0 {
            experienceMaterial.diffuse.contents = UIColor(red: 162/256, green: 191/256, blue: 214/256, alpha: 1)
        } else {
            experienceMaterial.diffuse.contents = gameModel.experienceColors[experience.colorIndex]
        }
        geometry.materials = [experienceMaterial]
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(0.1, 0.1, 0.1)
        experienceNode.position = position
        experienceNode.hidden = true
        worldNode.addChildNode(experienceNode)
        let actionWait = SCNAction.waitForDuration(delay)
        experienceNode.runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionLiftExperience, SCNAction.removeFromParentNode()]))
    }
}