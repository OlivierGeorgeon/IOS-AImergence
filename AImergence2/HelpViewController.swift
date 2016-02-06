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
            textView?.text = helpBlobArray()[level]
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
            textView.text = helpBlobArray()[level]
        }
    }
    
    @IBAction func closeButton(sender: UIButton) {
        delegate?.close()
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 { level-- }
        else { level = HelpStruct.text.count - 1 }
    }

    @IBAction func nextButton(sender: UIButton) {
        if level < HelpStruct.text.count - 1 { level++ }
        else { level = 0 }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // seems to fix a bug that the textview wont display entirely
        textView.text = ""
        textView.text = HelpStruct.text[level]
    }
    
    func helpBlobArray() -> [String] {
        var helpBlobArray = [String]()
        if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist", inDirectory: nil, forLocalization: "fr") {
        //if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist") {
            let localizedDictionary = NSDictionary(contentsOfFile: path)
            if let helpLineArray = localizedDictionary?["Help"] as? [[String]] {
                helpBlobArray = helpLineArray.map({$0.reduce("", combine: {$0 + $1 + "\n\n"})})
            } else {
                print("The Help key of file Help.plist must only contain an array of arrays of strings.")
            }
        }
        return helpBlobArray
    }

}
