//
//  GameView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 27/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameViewDelegate: class
{
    func nextLevelScene() -> GameSKScene?
    func previousLevelScene() -> GameSKScene?
}

class GameView: SKView {
    
    weak var delegate: GameViewDelegate?

    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
    }
    
    func addBehavior (){
        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action: #selector(GameView.pan(_:)))
        addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.tap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameView.longPress(_:)))
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.pan(gesture)
        }
    }
    
    func tap(gesture:UITapGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.tap(gesture)
        }
    }
    
    func longPress(gesture:UILongPressGestureRecognizer) {
        if let scene = scene as? PositionedSKScene {
            scene.longPress(gesture)
        }
    }
    
    func nextLevel() {
        if let nextScene = delegate?.nextLevelScene() {
            presentScene(nextScene, transition: PositionedSKScene.transitionLeft)
        }
    }

    func previousLevel() {
        if let previousScene = delegate?.previousLevelScene() {
            presentScene(previousScene, transition: PositionedSKScene.transitionRight)
        }
    }
}