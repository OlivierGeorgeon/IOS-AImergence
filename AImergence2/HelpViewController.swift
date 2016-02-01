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

    var level:Int = 0 {
        didSet {
            labelView?.text = "Level \(level)"
            textView?.text = helpStruct.help()[level]
        }
    }
    
    @IBOutlet weak var labelView: UILabel! {
        didSet {
            labelView.text = "Level \(level)"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = helpStruct.help()[level]
        }
    }
    
    @IBAction func closeButton(sender: UIButton) {
        view.hidden = true
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 {level--}
    }

    @IBAction func nextButton(sender: UIButton) {
        if level < helpStruct.help().count - 1 {level++ }
    }
    
}
