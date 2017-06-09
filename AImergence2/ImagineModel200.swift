//
//  WorldScene1.swift
//  AImergence
//
//  Created by Olivier Georgeon on 11/02/16.
//  CC0 No rights reserved.
//

import SceneKit

class ImagineModel200: ImagineModel002
{
    let leftHolderNode = SCNNode()
    let rightHolderNode = SCNNode()
    
    override func setup(_ scene: SCNScene) {
        super.setup(scene)
        //leftHolderNode.position = SCNVector3(8, -5, 8)
        //leftHolderNode.rotation = SCNVector4(0, 1, 0, CGFloat(-M_PI) / 4)
        leftHolderNode.position = SCNVector3(5, -5, 10)
        leftHolderNode.rotation = SCNVector4(0, 1, 0, CGFloat(-M_PI) / 2)
        worldNode.addChildNode(leftHolderNode)
        rightHolderNode.position = SCNVector3(-5, -5, 10)
        rightHolderNode.rotation = SCNVector4(0, 1, 0, CGFloat(M_PI) / 2)
        worldNode.addChildNode(rightHolderNode)
        
    }
    override func imagine(experience: Experience) {
        switch experience.hashValue {
        case 00: // feel left red
            robotNode.feelFrontLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), parentNode: leftHolderNode, direction: .south)
                leftFlippableNode?.appear(0.2)
            } else {
                leftFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: SCNVector3(5, -5, 7), delay: 0.2)
        case 01: // feel left green
            robotNode.feelFrontLeft()
            if leftFlippableNode == nil  {
                leftFlippableNode = createFlipTileNode(tileColor(experience), parentNode: leftHolderNode)
                leftFlippableNode?.appear(0.2)
            }
            spawnExperienceNode(experience, position: SCNVector3(5, -5, 7), delay: 0.2)
        case 10: // flip left red
            robotNode.jumpLeft()
            if leftFlippableNode == nil {
                leftFlippableNode = createFlipTileNode(nil, parentNode: leftHolderNode)
            }
            leftFlippableNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.4)
            spawnExperienceNode(experience, position: leftHolderNode.position, delay: 0.4)
        case 11: // flip left green
            robotNode.jumpLeft()
            if leftFlippableNode == nil {
                leftFlippableNode = createFlipTileNode(nil, parentNode: leftHolderNode, direction: .south)
            }
            leftFlippableNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: false, delay: 0.4)
            spawnExperienceNode(experience, position: leftHolderNode.position, delay: 0.4)
        case 20, 21, 22:
            robotNode.feelFront()
            spawnExperienceNode(experience, position: SCNVector3(0, 0, 7) + tileYOffset, delay: 0.2)
        case 30: // feel right red
            robotNode.feelFrontRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), parentNode: rightHolderNode, direction: .south)
                rightFlippableNode?.appear(0.2)
            } else {
                rightFlippableNode?.colorize(tileColor(experience), delay: 0.2)
            }
            spawnExperienceNode(experience, position: SCNVector3(-5, -5, 7), delay: 0.2)
        case 31: // feel right green
            robotNode.feelFrontRight()
            if rightFlippableNode == nil  {
                rightFlippableNode = createFlipTileNode(tileColor(experience), parentNode: rightHolderNode)
                rightFlippableNode?.appear(0.2)
            }
            spawnExperienceNode(experience, position: SCNVector3(-5, -5, 7), delay: 0.2)
        case 40: // flip right red
            robotNode.jumpRight()
            if rightFlippableNode == nil {
                rightFlippableNode = createFlipTileNode(nil, parentNode: rightHolderNode)
            }
            rightFlippableNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: true, delay: 0.4)
            spawnExperienceNode(experience, position: rightHolderNode.position, delay: 0.4)
        case 41: // flip right green
            robotNode.jumpRight()
            if rightFlippableNode == nil {
                rightFlippableNode = createFlipTileNode(nil, parentNode: rightHolderNode, direction: .south)
            }
            rightFlippableNode?.appearAndFlipAndColorize(tileColor(experience), clockwise: true, delay: 0.4)
            spawnExperienceNode(experience, position: rightHolderNode.position, delay: 0.4)
        default:
            break
        }
    }
    
    func createFlipTileNode(_ color: UIColor?, parentNode: SCNNode, direction:Compass = .north) -> SCNFlipTileNode {
        let node = SCNFlipTileNode(color: color, direction: direction)
        parentNode.addChildNode(node)
        return node
    }

    
}
