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
    //var cameraNodes = [SCNNode]()
    var worldNode = SCNNode()
    var bodyNode: SCNFlippableNode!

    var robotNode: SCNRobotNode!
    //var tiles = [Cell: SCNNode]()
    var constraint: SCNLookAtConstraint!
    let tileYOffset = SCNVector3(0, -5, 0)

    required init(gameModel: GameModel2) {
        self.gameModel = gameModel
    }
    
    func playExperience(experience: Experience) {
    }
        
    
}