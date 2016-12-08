//
//  MultiplayerExtension.swift
//  Little AI
//
//  Created by Olivier Georgeon on 05/12/2016.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import GameKit

extension GameViewController: GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener
{    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print("Did find match")
        if match.players.count > 0 {
            remotePlayerDisplayName = match.players[0].displayName!
        }
        viewController.dismiss(animated: true, completion: nil)
        match.delegate = self
        self.match = match
        if let scene = self.sceneView.scene as? GameSKScene {
            scene.level.remoteExperimentNumber = nil
            // remove previous experiments to avoid asynchronicity
            if scene.localExpermimentNode != nil {
                scene.localExpermimentNode?.removeAction(forKey: "pulse")
                scene.localExpermimentNode = nil
            }
            scene.tutorNode.matched()
            scene.matchNode.update(status: .connected)
            scene.matchNode.update(displayName: remotePlayerDisplayName)
            scene.matchNode.update(text: NSLocalizedString("Ready", comment: ""))
        }
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        print("Match cancelled")
        viewController.dismiss(animated: true, completion: nil)
        //if let scene = self.sceneView.scene as? GameSKScene {
        //    scene.tutorNode.matched()
        //}
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController,  didFailWithError error: Error) {
        print("Match failed")
        viewController.dismiss(animated: true, completion: nil)
        if let scene = self.sceneView.scene as? GameSKScene {
            scene.tutorNode.matched()
            scene.matchNode.update(status: .disconnected)
            remotePlayerDisplayName = nil
            //self.match = nil
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print("receive data:")
        if self.match == match  {
            if data.count > 1 {
                if let scene = self.sceneView.scene as? GameSKScene {
                    scene.remoteExperiment(number: Int(data[0]))
                    print(Int(data[0]))
                    let text = NSLocalizedString("Level", comment: "") + " \(Int(data[1]))"
                    scene.matchNode.update(text: text)
                }
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if state == .stateConnected {
            if let scene = self.sceneView.scene as? GameSKScene {
                scene.matchNode.update(status: .connected)
                scene.matchNode.update(displayName: player.displayName)
                scene.matchNode.update(text: NSLocalizedString("Ready", comment: ""))
            }
        } else {
            if let scene = self.sceneView.scene as? GameSKScene {
                scene.matchNode.update(status: .disconnected)
                scene.matchNode.update(displayName: "")
                scene.matchNode.update(text: "")
                remotePlayerDisplayName = nil
                // self.match = nil test to see if it causes crash
            }
        }
        print("Player state change: \(state.rawValue)")
    }
    
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        return false
    }
    
    // This is called on the invitee's device after she receives an invitation from the inviter
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        print("did accept invite player: \(player.displayName) invite_sender: \(invite.sender.displayName)")
        let level = invite.playerGroup
        if level >= 21 && level <= 22 {
            let gameScene = GameSKScene(levelNumber: level)
            gameScene.gameSceneDelegate = self
            self.sceneView.presentScene(gameScene)
        }
        
        let mmvc: GKMatchmakerViewController = GKMatchmakerViewController(invite: invite)!
        mmvc.matchmakerDelegate = self
        self.present(mmvc, animated: true, completion: nil)
    }
}
