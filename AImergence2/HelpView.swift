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
    
    // Test for motion effect
    @IBInspectable var test2 =  0 { didSet { print("test \(test2)" )}}
    
    @IBInspectable var test: CGFloat {
        get {
            print("get var test \(center.x)")
            return center.x
        }
        set(newX) {
            center.x = newX
            print("set var test \(center.x)")
        }
    }
    
   override func drawRect(rect: CGRect) {
        UIColor.whiteColor().set()
        UIBezierPath(roundedRect: rect, cornerRadius: 10).fill()
    }
}