//
//  HelpViewControler.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 23/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    let helpStruct = HelpStruct()

    @IBOutlet weak var labelView: UILabel! {
        didSet {
            labelView.text = "Level \(level)"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            //textView.text = text
            textView.text = helpStruct.help()[level]
        }
    }
    
    var level:Int = 0 {
        didSet {
            labelView?.text = "Level \(level)"
            textView?.text = helpStruct.help()[level]
        }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        if level < helpStruct.help().count - 1 {level++ }
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 {level--}
    }

    override var preferredContentSize: CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return super.preferredContentSize
                //return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue}
    }
    
}
