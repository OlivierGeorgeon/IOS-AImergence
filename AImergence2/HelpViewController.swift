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
            if level == 0 { previousButtonOutlet.enabled = false }
            else { previousButtonOutlet.enabled = true }
            if level == HomeStruct.numberOfLevels { nextButtonOutlet.enabled = false }
            else { nextButtonOutlet.enabled = true }
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
        delegate?.closeHelpView()
    }
    
    @IBAction func previousButton(sender: UIButton) {
        if level > 0 { level-- }
    }

    @IBOutlet weak var previousButtonOutlet: UIButton! {
        didSet { previousButtonOutlet.enabled = false }
    }
    
    @IBAction func nextButton(sender: UIButton) {
        if level < HomeStruct.numberOfLevels { level++ }
    }
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // seems to fix a bug that the textview won't display entirely
        textView.text = ""
        textView.text = helpBlobArray[level]
    }
}
