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
    let titleFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    let priceNode = SKLabelNode()
    
    var product: SKProduct?
    
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "tip")
        super.init(texture: texture, color: UIColor.clear, size: size)

        priceNode.fontName = bodyFont.fontName
        priceNode.fontColor = UIColor.darkGray
        priceNode.verticalAlignmentMode = .center
        priceNode.position.x = self.size.width * -0.05
        priceNode.zPosition = 1
        priceNode.fontSize = titleFont.pointSize * 2
        addChild(priceNode)
    }
    
    convenience init(product: SKProduct, size: CGSize) {
        self.init(size: size)

        self.product = product
        priceNode.text = localizedPrice(product)
        while priceNode.frame.size.width >= self.size.width * 0.8 {
            priceNode.fontSize -= 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func product(_ product: SKProduct) {
        self.product = product
        priceNode.text = localizedPrice(product)
        while priceNode.frame.size.width >= self.size.width * 0.8 {
            priceNode.fontSize -= 1
        }
    }
    
    func localizedPrice(_ product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)!
    }
}
