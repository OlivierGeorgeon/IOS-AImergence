//
//  TipSKNode.swift
//  Little AI
//
//  Created by Olivier Georgeon on 09/07/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import SpriteKit
import StoreKit

class TipSKNode: SKSpriteNode
{
    let product: SKProduct
    
    init(product: SKProduct, size: CGSize) {
        self.product = product
        
        let texture = SKTexture(imageNamed: "tip")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)

        let priceNode = SKLabelNode(text: localizedPrice(product))
        priceNode.fontName = PositionedSKScene.bodyFont.fontName
        priceNode.fontSize = PositionedSKScene.titleFont.pointSize
        priceNode.fontColor = UIColor.darkGrayColor()
        priceNode.verticalAlignmentMode = .Center
        priceNode.position.x = self.size.width * -0.03
        priceNode.zPosition = 1
        while priceNode.frame.size.width >= self.size.width * 0.9 {
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