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
    
    let helpBlobArray:[String]
    let levelString = NSLocalizedString("Level", comment: "the game level displayed in the header of the help window")
    
    var level:Int = 0 {
        didSet {
            labelView?.text = levelString + " \(level)"
            textView?.text = helpBlobArray[level]
        }
    }
    
    var delegate: HelpViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder)
    {
        var tempHelpBlobArray = [String]()
        if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist", inDirectory: nil, forLocalization: "fr") {
        //if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist") {
            let localizedDictionary = NSDictionary(contentsOfFile: path)
            if let helpLineArray = localizedDictionary?["Help"] as? [[String]] {
                tempHelpBlobArray = helpLineArray.map({$0.reduce("", combine: {$0 + $1 + "\n\n"})})
            } else {
                print("The Help key of file Help.plist must only contain an array of arrays of strings.")
            }
        }
        helpBlobArray = tempHelpBlobArray
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var labelView: UILabel! {
        didSet {
            labelView.text = levelString + " \(level)"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = helpBlobArray[level]
        }
    }
    
    @IBAction func closeButton(sender: UIButton) {
        delegate?.close()
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 { level-- }
        else { level = HomeStruct.numberOfLevels - 1 }
    }

    @IBAction func nextButton(sender: UIButton) {
        if level < HomeStruct.numberOfLevels - 1 { level++ }
        else { level = 0 }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // seems to fix a bug that the textview won't display entirely
        textView.text = ""
        textView.text = helpBlobArray[level]
    }
}
