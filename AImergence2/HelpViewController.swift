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
    func closeHelpView()
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
                tempHelpBlobArray = helpLineArray.map({$0.reduce("", combine: {$0 + "\n\n" + $1 }).stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())})
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
        delegate?.closeHelpView()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // seems to fix a bug that the textview won't display entirely
        textView.text = ""
        textView.text = helpBlobArray[level]
    }
}
