//
//  HelpView.swift
//  AImergence
//
//  Created by Olivier Georgeon on 01/02/16.
//  CC0 No rights reserved.
//

import UIKit

class HelpView: UIView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
    }
    
    func addBehavior (){
        // Intercepts the gestures so they are not exectued in the GameView
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target:self, action: #selector(HelpView.pan(_:)))
        //panGestureRecognizer.cancelsTouchesInView = false
        //addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HelpView.tap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(HelpView.longPress(_:)))
        longPressGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(longPressGestureRecognizer)
    }

    func pan(_ gesture: UIPanGestureRecognizer) {}
    func tap(_ gesture:UITapGestureRecognizer) {}
    func longPress(_ gesture:UILongPressGestureRecognizer) {}
    
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIBezierPath(roundedRect: rect, cornerRadius: 10).fill()
    }
}
