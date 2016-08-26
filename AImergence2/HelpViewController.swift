//
//  HelpViewControler.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 23/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

protocol HelpViewControllerDelegate: class
{
    func hideHelpViewControllerContainer()
    func understandInstruction()
}

class HelpViewController: UIViewController {
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var textView:  UITextView!
    @IBAction func closeButton(sender: UIButton) { delegate?.hideHelpViewControllerContainer() }
    @IBAction func UnderstoodButton(sender: UIButton) {
        delegate?.understandInstruction()
        delegate?.hideHelpViewControllerContainer()
    }
    
    let helpBlobArray:[String]
    let levelString = NSLocalizedString("Level", comment: "the game level displayed in the header of the help window")
    
    weak var delegate: HelpViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder)
    {
        var tempHelpBlobArray = [String]()
        //if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist", inDirectory: nil, forLocalization: "fr") {
        if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist") {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLevel(0)
}
    
    func displayLevel(level: Int) {
        labelView.text = levelString + " \(level)"
        switch level {
        case 16:
            textView.selectable = true
        default:
            textView.selectable = false
        }
        textView.text = helpBlobArray[level]
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            // Seems to fix a Swift bug that does not refresh the textview properly
            self.textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        })
    }
}
