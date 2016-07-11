//
//  TipSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 09/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit

class TipSKNode: SKSpriteNode
{
    let product: SKProduct
    let tipColor = UIColor.darkGrayColor()
    //let tipColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
    
    init(product: SKProduct, size: CGSize) {
        self.product = product
        
        super.init(texture: nil, color: UIColor.clearColor(), size: size)

        let backgroundNode = SKShapeNode(ellipseOfSize: size)
        backgroundNode.strokeColor = tipColor
        backgroundNode.lineWidth = 2
        backgroundNode.fillColor = UIColor(red: 0.95, green: 1.0, blue: 0.95, alpha: 1)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        let priceNode = SKLabelNode(text: localizedPrice(product))
        priceNode.fontName = PositionedSKScene.bodyFont.fontName
        priceNode.fontSize = PositionedSKScene.titleFont.pointSize
        priceNode.fontColor = tipColor
        priceNode.verticalAlignmentMode = .Center
        while priceNode.frame.size.width >= self.size.width {
            priceNode.fontSize -= 1.0
        }

        addChild(priceNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func localizedPrice(product: SKProduct) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = product.priceLocale
        return formatter.stringFromNumber(product.price)!
    }
}