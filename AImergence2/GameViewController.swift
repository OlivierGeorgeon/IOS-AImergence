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

enum INTERFACE: Int { case INSTRUCTION, IMAGINE, LEADERBOARD, LEVEL}

class GameViewController: UIViewController, GameSceneDelegate, MenuSceneDelegate, HelpViewControllerDelegate, ImagineViewControllerDelegate, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, GameViewDelegate //, GKMatchmakerViewControllerDelegate,  GKMatchDelegate
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
    //@IBAction func worldButton(sender: UIButton) { showImagineWindow() }
    
    var smallPortraitConstraint: NSLayoutConstraint?
    
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    let gcLoginMessage = NSLocalizedString("Please login to Game Center", comment: "Alert message that shows when the user tries to access the leaderboard without being logged in.")

    var helpViewController:  HelpViewController?
    var imagineViewController: ImagineViewController?
    var level = 0 {
        didSet {
            levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", forState: .Normal)
            //levelButton.setTitle("\(level)", forState: .Normal)
            if !helpViewControllerContainer.hidden { helpViewController?.displayLevel(level) }
            //if !imagineViewControllerContainer.hidden { imagineViewController?.displayLevel(level) }
        }
    }

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [true, true, true, true])
    var paidTip = false
    
    let product_id = "com.oliviergeorgeon.little_ai.tip1"
    var validProducts = [SKProduct]()
    var match: GKMatch?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.authenticateLocalPlayer()
 
        paidTip = userDefaults.boolForKey(paidTipKey)
        
        let userInterfaceLocksWrapped = userDefaults.arrayForKey(unlockDefaultKey)
        if let userInterfaceLocks = userInterfaceLocksWrapped as? [[Bool]] {
            for i in 0...(userInterfaceLocks.count - 1) {
                if interfaceLocks[i].count == userInterfaceLocks[i].count {
                    interfaceLocks[i] = userInterfaceLocks[i]
                }
            }
        }
        if Process.arguments.count > 1 {
            if Process.arguments[1] == "unlocked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [false, false, false, false])
            }
            if Process.arguments[1] == "locked" {
                interfaceLocks = [[Bool]](count: GameViewController.maxLevelNumber + 1, repeatedValue: [true, true, true, true])
            }
        }
        
        //let longPressButtonGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameViewController.longPressLevel(_:)))
        //levelButton.addGestureRecognizer(longPressButtonGestureRecognizer)
        
        //let gameModel = GameModel.createGameModel(0)
        let gameScene = GameSKScene(levelNumber: 0)
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
        if !interfaceLocks[level][INTERFACE.LEVEL.rawValue] && level < GameViewController.maxLevelNumber {
            level += 1
            //let gameModel = GameModel.createGameModel(level)
            nextGameScene = GameSKScene(levelNumber: level)
            nextGameScene!.gameSceneDelegate = self
            closeImagineWindow()
        }
        return nextGameScene
    }
    
    func previousLevelScene() -> GameSKScene? {
        var previousGameScene:GameSKScene? = nil
        if level > 0 {
            level -= 1
            //let gameModel = GameModel.createGameModel(level)
            previousGameScene = GameSKScene(levelNumber: level)
            previousGameScene!.gameSceneDelegate = self
            closeImagineWindow()
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
    func isGameCenterEnabled() -> Bool {
        return gcEnabled
    }
    
    func playExperience(experience: Experience) {
        if !imagineViewControllerContainer.hidden {
            imagineViewController?.playExperience(experience)
        }
    }
    
    func showInstructionWindow() {
        imagineViewControllerContainer.hidden = true
        imagineViewController?.sceneView.scene = nil
        helpViewController?.displayLevel(level)
        helpViewControllerContainer.hidden = false
    }
    
    func isInterfaceLocked(interface: INTERFACE) -> Bool {
        return interfaceLocks[level][interface.rawValue]
    }

    func showImagineWindow(gameModel: GameModel0) {
        helpViewControllerContainer.hidden = true
        if isInterfaceLocked(INTERFACE.LEVEL) {
            imagineViewController?.displayLevel(nil, okEnabled: true)
        } else {
            imagineViewController?.displayLevel(gameModel, okEnabled: !isInterfaceLocked(INTERFACE.IMAGINE))
        }
        imagineViewControllerContainer.hidden = false
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
                if !self.isInterfaceLocked(INTERFACE.LEVEL) {
                    if let scene = self.sceneView.scene as? GameSKScene {
                        if scene.robotNode.recommendation == RECOMMEND.LEADERBOARD {
                            scene.robotNode.recommend(RECOMMEND.DONE)
                        }
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
    /*
    func presentMatchMakingViewController(mmvc: GKMatchmakerViewController) {
        mmvc.matchmakerDelegate = self
        self.presentViewController(mmvc, animated: true, completion: nil)
    }

    optional func matchmakerViewController(_ viewController: GKMatchmakerViewController,
                                             didFindMatch match: GKMatch) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        match.delegate = self
        self.match = match
    }
    
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController,
                                    didFailWithError error: NSError) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    optional func match(_ match: GKMatch, didReceiveData data: NSData, fromRemotePlayer player: GKPlayer) {
        if self.match != match  {
            return
        }
        let p = data.bytes

        // Handle a position message.
    }
    
    optional func match(_ match: GKMatch, player player: GKPlayer, didChangeConnectionState state: GKPlayerConnectionState) {
        
    }
    
    optional func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        
    }
    */
    func unlockLevel(moves: Int) {
        if gcEnabled {
            let sScore = GKScore(leaderboardIdentifier: "Level\(level)")
            sScore.value = Int64(moves)
            let sLevels = GKScore(leaderboardIdentifier: "Levels")
            sLevels.value = Int64(level)
            GKScore.reportScores([sLevels, sScore], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Score submitted: \(moves) moves in Level \(self.level)")
                }
            })
        }
        
        if isInterfaceLocked(INTERFACE.LEVEL) {
            interfaceLocks[level][INTERFACE.LEVEL.rawValue] = false
            userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
            //if !imagineViewControllerContainer.hidden {
            //    imagineViewController?.displayLevel(scene.gameModel)
            //}
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
            if !interfaceLocks[level - 1][INTERFACE.LEVEL.rawValue]
                {levelStatus = 1 }
        }
        if !interfaceLocks[level][INTERFACE.LEVEL.rawValue]
            { levelStatus = 2 } // unlocked
        return levelStatus
    }

    // Implement HelpViewControllerDelegate
    func hideHelpViewControllerContainer() {
        helpViewControllerContainer.hidden = true
    }
    
    func understandInstruction() {
        interfaceLocks[level][INTERFACE.INSTRUCTION.rawValue] = false
        userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            scene.tutorNode.instructionOk(scene.robotNode.imagineButtonNode)
            scene.robotNode.instructionButtonNode.disactivate()
            scene.robotNode.instructionButtonNode.unpulse()
            if scene.robotNode.recommendation == RECOMMEND.INSTRUCTION {
                scene.robotNode.recommend(RECOMMEND.INSTRUCTION_OK)
            }
            if !isInterfaceLocked(INTERFACE.LEVEL) && scene.robotNode.recommendation == RECOMMEND.INSTRUCTION_OK {
                scene.robotNode.recommend(RECOMMEND.IMAGINE)
            }
        }
    }
    
    // Implement WorldViewControllerDelegate
    func closeImagineWindow() {
        imagineViewControllerContainer.hidden = true
        imagineViewController!.imagineModel = nil
        imagineViewController!.sceneView.scene = nil
    }
    
    /*func getGameModel() -> GameModel2 {
        var gameModel = GameModel2()
        if let scene = sceneView.scene as? GameSKScene {
            gameModel = scene.gameModel
        }
        return gameModel
    }*/
    
    func acknowledgeImagineWorld() {
        if !isInterfaceLocked(INTERFACE.LEVEL) {
            interfaceLocks[level][INTERFACE.IMAGINE.rawValue] = false
            userDefaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
            if let scene = sceneView.scene as? GameSKScene {
                scene.tutorNode.robotOk(scene.robotNode)
                scene.robotNode.imagineButtonNode.disactivate()
                //if scene.robotNode.imagineButtonNode.pulsing {
                    //scene.robotNode.imagineButtonNode.unpulse()
                    if scene.robotNode.recommendation == RECOMMEND.IMAGINE {
                        scene.robotNode.recommend(RECOMMEND.LEADERBOARD)
                        if gcEnabled {
                            scene.robotNode.gameCenterButtonNode.pulse()
                        }
                    }
                //}
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
            scene.robotNode.gameCenterButtonNode.disactivate()
            if isInterfaceLocked(INTERFACE.LEADERBOARD) {
                interfaceLocks[level][INTERFACE.LEADERBOARD.rawValue] = false
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(interfaceLocks, forKey: unlockDefaultKey)
            }
            if scene.robotNode.recommendation == RECOMMEND.LEADERBOARD {
                scene.robotNode.recommend(RECOMMEND.DONE)
            }
        }
    }
}
