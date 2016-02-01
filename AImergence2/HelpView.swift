//
//  HelpView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 01/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

@IBDesignable

class HelpView: UIView {
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask =  UIViewAutoresizing.FlexibleTopMargin
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        autoresizingMask =  UIViewAutoresizing.FlexibleTopMargin
    }*/

    override func drawRect(rect: CGRect) {
        UIColor.whiteColor().set()
        UIBezierPath(roundedRect: rect, cornerRadius: 10).fill()
    }
}