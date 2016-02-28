//
//  GameView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 27/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

class GameView: SKView {

    // Test for motion effect
    var backgroundNodeX: CGFloat {
        get {
            print("get")
            return ((scene as! PositionedSKScene).backgroundNode?.position.x)!
        }
        set(newX) {
            (scene as! PositionedSKScene).backgroundNode?.position.x = newX
            print("set")
            print(newX)
        }
    }
}