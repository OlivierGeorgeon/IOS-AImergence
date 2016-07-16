//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  Copyright (c) 2016 Olivier Georgeon. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import StoreKit

class GameViewController: UIViewController, GameSceneDelegate, MenuSceneDelegate, HelpViewControllerDelegate, WorldViewControllerDelegate, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, GameViewDelegate
{
    static let maxLevelNumber = 17
    let unlockDefaultKey = "unlockDefaultKey"
    let paidTipKey = "paidTipKey"
    
    @IBOutlet weak var sceneView: GameView!
    @IBOutlet weak var helpViewControllerContainer: UIView!
    @IBOutlet weak var imagineViewControllerContainer: UIView!
    @IBOutlet weak var levelButton: UIButton!
    @IBAction func levelButton(sender: UIButton) { showLevelWindow() }
    @IBAction func hepButton(sender: UIButton)   { showInstructionWindow() }
    @IBAction func worldButton(sender: UIButton) { showImagineWindow() }
    
    var smallPortraitConstraint: NSLayoutConstraint?
    
    var score: Int = 0 // Stores the score
    
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    let gcLoginMessage = NSLocalizedString("Please login to Game Center", comment: "Alert message that shows when the user tries to access the leaderboard without being logged in.")

    var helpViewController:  HelpViewController?
    var imagineViewController: ImagineViewController?
    var level = 0 {
        didSet {
            levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            //levelButton.setTitle("\(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }

    static let instructionInterfaceIndex = 0
    static let imagineInterfaceIndex = 1
    static let levelInterfaceIndex = 2

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, false])
    var paidTip = false
    
    let product_id = "com.oliviergeorgeon.little_ai.tip1"
    var validProducts = [SKProduct]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.authenticateLocalPlayer()
 
        paidTip = userDefaults.boolForKey(paidTipKey)
        
        let userInterfaceLocksWrapped = userDefaults.arrayForKey(unlockDefaultKey)
        if let userInterfaceLocks = userInterfaceLocksWrapped as? [[Bool]] {
            for i in 0...(userInterfaceLocks.count - 1) {
                interfaceLocks[i] = userInterfaceLocks[i]
            }
        }
        if Process.arguments.count > 1 {
            if Process.arguments[1] == "unlocked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, true])
            }
            if Process.arguments[1] == "locked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, false])
            }
        }
        
        let gameModel = GameModel.createGameModel(0)
        let gameScene = GameSKScene(gameModel: gameModel)
        gameScene.gameSceneDelegate = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        sceneView.delegate = self
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
        sceneView.ignoresSiblingOrder = true
        sceneView.presentScene(gameScene)
        
        smallPortraitConstraint = NSLayoutConstraint(item: imagineViewControllerContainer, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -120)
        smallPortraitConstraint?.active = false
        view.addConstraint(smallPortraitConstraint!)

        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProducts()
    }
    
    func leaveTip(product: SKProduct) {
        buyProduct(product);
    }

    func requestProducts() {
        if SKPaymentQueue.canMakePayments() {
            let productID: Set = ["com.oliviergeorgeon.little_ai.tip1", "com.oliviergeorgeon.little_ai.tip2", "com.oliviergeorgeon.little_ai.tip3"]
            let productRequest = SKProductsRequest(productIdentifiers: productID )
            productRequest.delegate = self
            productRequest.start()
            print("Fetching product")
        } else {
            print("Can't make purchase")
        }
    }
    
    func buyProduct(product: SKProduct) {
        print("sending the payment request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        validProducts = response.products
        print("Recieved \(validProducts.count) products from Apple.")
    }
    
    func getProducts() -> [SKProduct] {
        return validProducts
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error fetching product information")
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received payment transaction reponse from apple")
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .Purchased:
                    print("Product purchased")
                    paidTip = true
                    userDefaults.setBool(true, forKey: paidTipKey)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                case .Failed:
                    print("Purchased failed")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                case .Restored:
                    print("Already purchased")
                    paidTip = true
                    userDefaults.setBool(true, forKey: paidTipKey)
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                default:
                    break
                }
            }
        }
    }

    func isPaidTip() -> Bool {
        return paidTip
    }
    
    func nextLevelScene() -> GameSKScene? {
        var nextGameScene:GameSKScene? = nil
        if interfaceLocks[level][GameViewController.levelInterfaceIndex] && level < GameViewController.maxLevelNumber {
            level += 1
            let gameModel = GameModel.createGameModel(level)
            nextGameScene = GameSKScene(gameModel: gameModel)
            nextGameScene!.gameSceneDelegate = self
            hideImagineViewControllerContainer()
        }
        return nextGameScene
    }
    
    func previousLevelScene() -> GameSKScene? {
        var previousGameScene:GameSKScene? = nil
        if level > 0 {
            level -= 1
            let gameModel = GameModel.createGameModel(level)
            previousGameScene = GameSKScene(gameModel: gameModel)
            previousGameScene!.gameSceneDelegate = self
            hideImagineViewControllerContainer()
        }
        return previousGameScene
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowHelp":
                helpViewController = segue.destinationViewController as? HelpViewController
                helpViewController!.delegate = self
            case "ShowWorld":
                imagineViewController = segue.destinationViewController as? ImagineViewController
                imagineViewController!.delegate = self
            default:
                break
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if let positionedScene = sceneView.scene as? PositionedSKScene {
            positionedScene.positionInFrame(size)
        }
        
        if size.width < size.height {
            smallPortraitConstraint?.active = true
        } else {
            smallPortraitConstraint?.active = false
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    // Implement GameSceneDelegate
    func playExperience(experience: Experience) {
        imagineViewController?.playExperience(experience)
    }
    
    func showInstructionWindow() {
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        helpViewController?.displayLevel(level)
        helpViewControllerContainer.hidden = false
    }
    
    func isLevelUnlocked() -> Bool {
        return interfaceLocks[level][GameViewController.levelInterfaceIndex]
    }
    
    func isInstructionUnderstood() -> Bool {
        return interfaceLocks[level][GameViewController.instructionInterfaceIndex]
    }
    
    func isImagineUnderstood() -> Bool {
        return interfaceLocks[level][GameViewController.imagineInterfaceIndex]
    }
    
    func isInterfaceUnlocked(interface: Int) -> Bool {
        return interfaceLocks[level][interface]
    }

    func showImagineWindow() {
        helpViewControllerContainer.hidden = true
        if imagineViewControllerContainer.hidden {
            imagineViewController?.displayLevel(level)
            imagineViewControllerContainer.hidden = false
        } else {
            imagineViewControllerContainer.hidden = true
            imagineViewController?.sceneView.scene = nil
        }
    }
    
    func showGameCenter() {
        if gcEnabled {
            let gcVC: GKGameCenterViewController = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
            //gcVC.leaderboardTimeScope = GKLeaderboardTimeScope.Today
            //gcVC.leaderboardIdentifier = "Levels"
            gcVC.leaderboardIdentifier = "Level\(level)" // GameCenter bug: it must be repeted in completion otherwise it is not working
            self.presentViewController(gcVC, animated: true, completion: {gcVC.leaderboardIdentifier = "Levels";gcVC.leaderboardIdentifier = "Level\(self.level)"})
        } else {
            let alert = UIAlertController(title: "", message: gcLoginMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> () in
                if self.isLevelUnlocked() {
                    if let scene = self.sceneView.scene as? GameSKScene {
                        scene.gameCenterButtonNode.unpulse()
                        scene.levelButtonNode.pulse()
                        scene.shiftButton()
                    }
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showLevelWindow() {
        helpViewControllerContainer.hidden = true
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        if let scene  = sceneView.scene as? GameSKScene {
            if validProducts.count == 0 {
                requestProducts()
            }
            let menuScene = MenuSKScene()
            menuScene.previousGameScene = scene
            menuScene.userDelegate = self
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            sceneView.presentScene(menuScene, transition: PositionedSKScene.transitionUp)
        }
        if let menuScene  = sceneView.scene as? MenuSKScene {
            sceneView.presentScene(menuScene.previousGameScene!, transition: PositionedSKScene.transitionDown)
        }
    }
    
    func unlockLevel(score: Int) {
        if gcEnabled {
            let sScore = GKScore(leaderboardIdentifier: "Level\(level)")
            sScore.value = Int64(score)
            let sLevels = GKScore(leaderboardIdentifier: "Levels")
            sLevels.value = Int64(level)
            GKScore.reportScores([sLevels, sScore], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Score submitted: \(score)")
                }
            })
        }
        
        if !isLevelUnlocked() {
            interfaceLocks[level][GameViewController.levelInterfaceIndex] = true
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
            if !imagineViewControllerContainer.hidden {
                imagineViewController?.displayLevel(level)
            }
        }
    }
    
    //Implement MenuSceneDelegate
    func currentlevel() -> Int {
        return level
    }
    
    func updateLevel(levelNumber: Int) {
        self.level = levelNumber
    }
    
    func levelStatus(level: Int) -> Int {
        var levelStatus = 0 // forbidden
        if level == 0 { levelStatus = 1 } //  allowed
        if level > 0 {
            if interfaceLocks[level - 1][GameViewController.levelInterfaceIndex]
                {levelStatus = 1 }
        }
        if interfaceLocks[level][GameViewController.levelInterfaceIndex]
            { levelStatus = 2 } // unlocked
        return levelStatus
    }

    // Implement HelpViewControllerDelegate
    func hideHelpViewControllerContainer() {
        helpViewControllerContainer.hidden = true
    }
    
    func understandInstruction() {
        interfaceLocks[level][GameViewController.instructionInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            scene.instructionButtonNode.disactivate()
            scene.instructionButtonNode.unpulse()
            if scene.currentButton == BUTTON.INSTRUCTION {
                scene.shiftButton()
            }
        }
    }
    
    // Implement WorldViewControllerDelegate
    func hideImagineViewControllerContainer() {
        imagineViewControllerContainer.hidden = true
        imagineViewController!.sceneView.scene = nil
    }
    
    func getGameModel() -> GameModel2 {
        var gameModel = GameModel2()
        if let scene = sceneView.scene as? GameSKScene {
            gameModel = scene.gameModel
        }
        return gameModel
    }
    
    func imagineOk() {
        interfaceLocks[level][GameViewController.imagineInterfaceIndex] = true
        userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            scene.imagineButtonNode.disactivate()
            if scene.imagineButtonNode.pulsing {
                scene.imagineButtonNode.unpulse()
                if gcEnabled {
                    scene.gameCenterButtonNode.pulse()
                }
                scene.shiftButton()
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                //self.presentViewController(ViewController!, animated: true, completion: nil)
                self.gcEnabled = false
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true                
                // Get the default leaderboard ID
                /*localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })*/
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        //print(gameCenterViewController.leaderboardIdentifier)
        if let scene = sceneView.scene as? GameSKScene {
            if isInterfaceUnlocked(2) {
                scene.gameCenterButtonNode.disactivate()
            }
            if scene.gameCenterButtonNode.pulsing {
                scene.gameCenterButtonNode.unpulse()
                scene.levelButtonNode.pulse()
                scene.shiftButton()
            }
        }
    }
}
