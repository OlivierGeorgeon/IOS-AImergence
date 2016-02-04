//
//  HelpViewControler.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 23/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

protocol HelpViewControllerDelegate
{
    func close()
}

class HelpViewController: UIViewController {
    
    var level:Int = 0 {
        didSet {
            labelView?.text = NSLocalizedString("Level", comment: "") + " \(level)"
            textView?.text = HelpStruct.text[level]
        }
    }
    
    var delegate: HelpViewControllerDelegate?
    
    @IBOutlet weak var labelView: UILabel! {
        didSet {
            labelView.text = NSLocalizedString("Level", comment: "") + " \(level)"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = HelpStruct.text[level]
        }
    }
    
    @IBAction func closeButton(sender: UIButton) {
        delegate?.close()
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 {level--}
    }

    @IBAction func nextButton(sender: UIButton) {
        if level < HelpStruct.text.count - 1 {level++ }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // seems to fix a bug that the textview wont display entirely
        textView.text = ""
        textView.text = HelpStruct.text[level]
    }
}
