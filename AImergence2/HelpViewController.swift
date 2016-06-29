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

        /*
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "test", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        // Set horiztontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "test", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        //let helpView = view.subviews[0] as! HelpView
        view.addMotionEffect(group)
 */
}
    
    func displayLevel(level: Int) {
        labelView.text = levelString + " \(level)"
        textView.text = helpBlobArray[level]
        textView.font = UIFont.systemFontOfSize(15)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // seems to fix a bug that the textview won't display entirely
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //let temp = self.textView.text
            //self.textView.text = ""
            //self.textView.text = temp
            self.textView.font = UIFont.systemFontOfSize(15)
        })
    }
  
}
