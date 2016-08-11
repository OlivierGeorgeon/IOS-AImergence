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
    let titleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let product: SKProduct
    
    init(product: SKProduct, size: CGSize) {
        self.product = product
        
        let texture = SKTexture(imageNamed: "tip")
        super.init(texture: texture, color: UIColor.clearColor(), size: size)

        let priceNode = SKLabelNode(text: localizedPrice(product))
        priceNode.fontName = bodyFont.fontName
        priceNode.fontSize = titleFont.pointSize * 2
        priceNode.fontColor = UIColor.darkGrayColor()
        priceNode.verticalAlignmentMode = .Center
        priceNode.position.x = self.size.width * -0.05
        priceNode.zPosition = 1
        while priceNode.frame.size.width >= self.size.width * 0.8 {
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