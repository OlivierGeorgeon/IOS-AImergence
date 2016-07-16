//
//  HelpView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 01/02/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
   override func drawRect(rect: CGRect) {
        UIColor.whiteColor().set()
        UIBezierPath(roundedRect: rect, cornerRadius: 10).fill()
    }
}