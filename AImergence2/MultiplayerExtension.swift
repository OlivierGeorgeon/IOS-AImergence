//
//  MultiplayerExtension.swift
//  Little AI
//
//  Created by Olivier Georgeon on 05/12/2016.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameKit

extension GameViewController: GKMatchmakerViewControllerDelegate, GKMatchDelegate
{
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        print("Match: " + match.description)
        match.delegate = self
        self.match = match
        if let scene = self.sceneView.scene as? GameSKScene {
            scene.tutorNode.matched()
            scene.matchNode.update(status: .connected)
        }
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        print("Match cancelled")
        viewController.dismiss(animated: true, completion: nil)
        if let scene = self.sceneView.scene as? GameSKScene {
            scene.tutorNode.matched()
        }
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController,  didFailWithError error: Error) {
        print("Match failed")
        viewController.dismiss(animated: true, completion: nil)
        if let scene = self.sceneView.scene as? GameSKScene {
            scene.tutorNode.matched()
            scene.matchNode.update(status: .disconnected)
            self.match = nil
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if self.match == match  {
            if data.count > 0 {
                if let scene = self.sceneView.scene as? GameSKScene {
                    scene.remoteExperiment(number: Int(data[0]))
                }
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if state == .stateConnected {
            if let scene = self.sceneView.scene as? GameSKScene {
                scene.matchNode.update(status: .connected)
            }
        } else {
            if let scene = self.sceneView.scene as? GameSKScene {
                scene.matchNode.update(status: .disconnected)
                self.match = nil
            }
        }
        print("Player state change: \(state.rawValue)")
    }
    
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        return true
    }
}
