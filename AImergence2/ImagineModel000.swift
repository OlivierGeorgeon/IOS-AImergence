//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SceneKit

class ImagineModel000
{    
    let gameModel: GameModel0
    let actionLiftExperience = SCNAction.moveBy( x: 0.0, y: 5.0 * 10, z: 0.0, duration: 3.0)
    let experienceRect = CGRect(x: CGFloat(-20), y: CGFloat(-20), width: CGFloat(40), height: CGFloat(40))
    let scale = Float(10)
    let worldNode = SCNNode()
    let tileYOffset = SCNVector3(0, -5, 0)

    var tileGeometries = [SCNBox]()
    var robotNode: SCNRobotNode!
    var constraint: SCNLookAtConstraint!

    required init(gameModel: GameModel0) {
        self.gameModel = gameModel

        for color in gameModel.experienceColors {
            let tileGeometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.specular.contents = UIColor.white
            tileGeometry.materials = [material]
            tileGeometries.append(tileGeometry)
        }
        
        let blueMaterial = SCNMaterial()
        //blueMaterial.diffuse.contents = UIColor(red: 140/256, green: 133/256, blue: 190/256, alpha: 1)
        blueMaterial.diffuse.contents = UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        blueMaterial.specular.contents = UIColor.white
        let tileGeometry = SCNBox(width: 1.0 * 10, height: 0.2 * 10, length: 1.0 * 10, chamferRadius: 0.1 * 10)
        tileGeometry.materials = [blueMaterial]
        tileGeometries[0] = tileGeometry
    }

    func setup(_ scene: SCNScene) {
        lightsAndCameras(scene)
        robotNode = SCNRobotNode()
        worldNode.addChildNode(robotNode)
    }
    
    func lightsAndCameras(_ scene: SCNScene)
    {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        //ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        //omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.light!.color = UIColor(white: 0.4, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50 * scale, 50 * scale)
        //omniLightNode.position = SCNVector3Make(50, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let omniLightNode2 = SCNNode()
        omniLightNode2.light = SCNLight()
        omniLightNode2.light!.type = SCNLight.LightType.omni
        //omniLightNode2.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode2.light!.color = UIColor(white: 0.4, alpha: 1.0)
        omniLightNode2.position = SCNVector3Make(50, 50, -50)
        scene.rootNode.addChildNode(omniLightNode2)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(4 * scale, 1 * scale, 4 * scale)
        cameraNode.runAction(SCNAction.rotateBy(x: 0, y: 0.75, z: 0, duration: 0))
        scene.rootNode.addChildNode(cameraNode)
        //cameraNodes.append(cameraNode)
        
        scene.rootNode.addChildNode(worldNode)
        
        //let originNode = SCNNode()
        //scene.rootNode.addChildNode(originNode)
        //let constraint = SCNLookAtConstraint(target: originNode)
        //constraint.gimbalLockEnabled = true
        //cameraNode.constraints = [constraint]
    }

    func imagine(experience: Experience) {
        switch experience.experiment.number {
        case 1:
            robotNode.bump()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellFront()) == nil  {
                createTileNode(tileColor(experience), position:robotNode.positionCell(robotNode.robot.cellFront()) + SCNVector3(3, -5, 0), delay: 0.1)
                //robotNode.knownCells.updateValue(tileNode, forKey: robotNode.robot.cellFront())
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellFront()) + tileYOffset, delay: 0.1)
        default:
            robotNode.bumpBack()
            if robotNode.knownCells.updateValue(Phenomenon.tile, forKey: robotNode.robot.cellBack()) == nil  {
                createTileNode(tileColor(experience), position:robotNode.positionCell(robotNode.robot.cellBack()) + SCNVector3(-0.5 * scale, -0.5 * scale, 0), chamferRadius: 0, delay: 0.1)
            }
            spawnExperienceNode(experience, position: robotNode.positionCell(robotNode.robot.cellBack()) + tileYOffset, delay: 0.1)
        }
    }
    
    func tileColor(_ experience: Experience) -> UIColor {
        if experience.colorIndex == 0 {
            return UIColor(red: 150/256, green: 150/256, blue: 150/256, alpha: 1)
        } else {
            return gameModel.experienceColors[experience.colorIndex]
        }
    }
    
    func createTileNode(_ color: UIColor, position: SCNVector3, chamferRadius:CGFloat = 1, delay: TimeInterval) {
        let node = SCNPhenomenonNode(color: color, chamferRadius: chamferRadius)
        node.position = position
        node.isHidden = true
        worldNode.addChildNode(node)
        node.appear(delay)
    }
    
    func spawnExperienceNode(_ experience: Experience, position: SCNVector3, delay:TimeInterval = 0.0) {
        let path = gameModel.experimentPaths[experience.experiment.shapeIndex](experienceRect)
        let geometry = SCNShape(path: path, extrusionDepth: CGFloat(10))
        let experienceMaterial = SCNMaterial()
        experienceMaterial.diffuse.contents = tileColor(experience)
        experienceMaterial.specular.contents = UIColor.white
        if #available(iOS 10.0, *) {
            experienceMaterial.metalness.contents = 1
        }
        geometry.materials = [experienceMaterial]
        let experienceNode = SCNNode(geometry: geometry)
        experienceNode.scale = SCNVector3(0.1, 0.1, 0.1)
        experienceNode.position = position
        experienceNode.isHidden = true
        worldNode.addChildNode(experienceNode)
        let actionWait = SCNAction.wait(duration: delay)
        experienceNode.runAction(SCNAction.sequence([actionWait, SCNAction.unhide(), actionLiftExperience, SCNAction.removeFromParentNode()]))
    }
    
    func imagine(experiment: Experiment) {
    }
    
    func imagine(remoteExperimentNumber: Int) {
    }
}
