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
    func instructionClose()
    func instructionOk()
}

class HelpViewController: UIViewController {
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var textView:  UITextView!
    @IBAction func closeButton(_ sender: UIButton) {
        delegate?.instructionClose()
    }
    @IBAction func UnderstoodButton(_ sender: UIButton) {
        delegate?.instructionOk()
    }
    
    let helpBlobArray:[String]
    let levelString = NSLocalizedString("Level", comment: "the game level displayed in the header of the help window")
    
    weak var delegate: HelpViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder)
    {
        var tempHelpBlobArray = [String]()
        //if let path = NSBundle.mainBundle().pathForResource("Help", ofType: "plist", inDirectory: nil, forLocalization: "fr") {
        if let path = Bundle.main.path(forResource: "Help", ofType: "plist") {
            let localizedDictionary = NSDictionary(contentsOfFile: path)
            if let helpLineArray = localizedDictionary?["Help"] as? [[String]] {
                tempHelpBlobArray = helpLineArray.map({$0.reduce("", {$0 + "\n\n" + $1 }).trimmingCharacters(in: CharacterSet.newlines)})
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
    
    func displayLevel(_ level: Int) {
        labelView.text = levelString + " \(level)"
        switch level {
        case 16:
            textView.isSelectable = true
        default:
            textView.isSelectable = false
        }
        textView.text = helpBlobArray[level]
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            // Seems to fix a Swift bug that does not refresh the textview properly
            self.textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        })
    }
}
