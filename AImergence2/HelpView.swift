//
//  HelpView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 01/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    // Test for motion effect @NSManaged
    dynamic var test2 =  0 { didSet { print("test \(test2)" )}}
    
    dynamic var test: CGFloat {
        get {
            print("get var test \(center.x)")
            return center.x
        }
        set(newX) {
            center.x = newX
            print("set var test \(center.x)")
        }
    }
    
    @NSManaged var toto: CGFloat
    
   override func drawRect(rect: CGRect) {
        UIColor.whiteColor().set()
        UIBezierPath(roundedRect: rect, cornerRadius: 10).fill()
    }
}