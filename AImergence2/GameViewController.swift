//
//  GameViewController.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 09/01/16.
//  CC0 No rights reserved. 
//

import UIKit
import SpriteKit
import GameKit
import StoreKit
import AVFoundation

enum INTERFACE: Int { case instruction, imagine, leaderboard, level}

class GameViewController: UIViewController, GameSceneDelegate, MenuSceneDelegate, HelpViewControllerDelegate, ImagineViewControllerDelegate, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, GameViewDelegate
{
    @IBOutlet weak var sceneView: GameView!
    @IBOutlet weak var helpViewControllerContainer: UIView!
    @IBOutlet weak var imagineViewControllerContainer: UIView!
    @IBOutlet weak var levelButton: UIButton!
    @IBAction func levelButton(_ sender: UIButton) { showLevelWindow() }
    
    //static let maxLevelNumber = 22
    static let maxGroupNumber = 2
    static let maxLevelNumberPerGroup = [17, 1, 2]
    
    let unlockDefaultKey = "unlockDefaultKey"
    let paidTipKey = "paidTipKey"
    let soundKey = "soundKey"
    let userHasDraggedLevelKey = "userHadDraggedLevelKey"
    let userHasDraggedGroupKey = "userHadDraggedGroupKey"
    let userDefaults = UserDefaults.standard
    let gcLoginMessage = NSLocalizedString("Please login to Game Center", comment: "Alert message that shows when the user tries to access the leaderboard without being logged in.")
    
    var instructionPortraitBottomConstraint = NSLayoutConstraint()
    var imaginePortraitBottomConstraint = NSLayoutConstraint()
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var helpViewController:  HelpViewController?
    var imagineViewController: ImagineViewController?
    var interfaceLocks = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: true, count: 4), count: 20), count: 3)
    var paidTip = false
    var userHasDraggedLevel = false
    var userHasDraggedGroup = false
    var validProducts = [SKProduct]()
    var match: GKMatch?
    var remotePlayerDisplayName: String?
    var soundDisabled = false
    var soundURLs = [URL]()
    var audioPlayer1: AVAudioPlayer?
    var audioPlayer2: AVAudioPlayer?
    
    var level = 0 {
        didSet {
            if level < 100 {
                levelButton.setTitle(NSLocalizedString("Level", comment: "") + " \(level)", for: UIControlState())
            } else {
                let groupLevel = String(format:" %01d.%02d", arguments: [level / 100, level % 100])
                levelButton.setTitle(NSLocalizedString("Level", comment: "") + groupLevel, for: UIControlState())
            }
            if !helpViewControllerContainer.isHidden {
                helpViewController?.displayLevel(level)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.authenticateLocalPlayer()
 
        paidTip = userDefaults.bool(forKey: paidTipKey)
        soundDisabled = userDefaults.bool(forKey: soundKey)
        userHasDraggedLevel = userDefaults.bool(forKey: userHasDraggedLevelKey)
        userHasDraggedGroup = userDefaults.bool(forKey: userHasDraggedGroupKey)
        for i in 1...13 {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "baby\(i)", ofType:"wav")!)
            soundURLs.append(url)
        }
        do {
            // Prevents the app from crashing when moving to background when another app is playing
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error shared audio session")
        }
        
        let userInterfaceLocksWrapped = userDefaults.array(forKey: unlockDefaultKey)
        if let userInterfaceLocks = userInterfaceLocksWrapped as? [[Bool]] {
            for i in 0...(min(userInterfaceLocks.count - 1, 19)) {
                if interfaceLocks[0][i].count == userInterfaceLocks[i].count {
                    interfaceLocks[0][i] = userInterfaceLocks[i]
                }
            }
        } else if userInterfaceLocksWrapped is [[[Bool]]] {
            interfaceLocks = userInterfaceLocksWrapped as! [[[Bool]]]
        }
        
        if CommandLine.arguments.count > 1 {
            if CommandLine.arguments[1] == "unlocked" {
                //interfaceLocks = [[Bool]](repeating: [false, false, false, false], count: GameViewController.maxLevelNumber + 1)
                interfaceLocks = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: false, count: 4), count: 20), count: 3)
            }
            if CommandLine.arguments[1] == "locked" {
                //interfaceLocks = [[Bool]](repeating: [true, true, true, true], count: GameViewController.maxLevelNumber + 1)
                interfaceLocks = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: true, count: 4), count: 20), count: 3)
            }
        }
        
        let gameScene = GameSKScene(levelNumber: 0)
        gameScene.gameSceneDelegate = self
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        sceneView.gameViewDelegate = self //Swift 3
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
        sceneView.ignoresSiblingOrder = true
        sceneView.presentScene(gameScene)
    
        instructionPortraitBottomConstraint = NSLayoutConstraint(item: helpViewControllerContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 0.67, constant: 0)
        instructionPortraitBottomConstraint.isActive = false
        view.addConstraint(instructionPortraitBottomConstraint)

        imaginePortraitBottomConstraint = NSLayoutConstraint(item: imagineViewControllerContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 0.67, constant: 0) // 120
        imaginePortraitBottomConstraint.isActive = false
        view.addConstraint(imaginePortraitBottomConstraint)
        
        SKPaymentQueue.default().add(self)
        requestProducts()
    }
    
    func isUserHasDraggedLevel() -> Bool {
        return userHasDraggedLevel
    }
    func isUserHasDraggedGroup() -> Bool {
        return userHasDraggedGroup
    }
    func userDragLevel() {
        userHasDraggedLevel = true
        userDefaults.set(userHasDraggedLevel, forKey: userHasDraggedLevelKey)
    }
    func userDragGroup() {
        userHasDraggedGroup = true
        userDefaults.set(userHasDraggedGroup, forKey: userHasDraggedGroupKey)
    }

    func leaveTip(_ product: SKProduct) {
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
    
    func buyProduct(_ product: SKProduct) {
        print("sending the payment request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        validProducts = response.products
        if let scene  = sceneView.scene as? MenuSKScene {
            scene.displayProducts(validProducts, isPaidTip: paidTip)
        }
        print("Recieved \(validProducts.count) products from Apple.")
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error fetching product information")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received payment transaction reponse from apple")
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    //print("Product purchased")
                    paidTip = true
                    userDefaults.set(true, forKey: paidTipKey)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let scene = sceneView.scene as? MenuSKScene {
                        scene.shortTipInvit = scene.thankYou
                        scene.longTipInvit = scene.thankYou
                        scene.tipInviteNode.text = scene.shortTipInvit
                    }
                case .failed:
                    //print("Purchased failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .restored:
                    //print("Already purchased")
                    paidTip = true
                    userDefaults.set(true, forKey: paidTipKey)
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    //SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break
                }
            }
        }
    }

    func nextLevelScene() -> GameSKScene? {
        var nextGameScene:GameSKScene? = nil
        let group = level / 100
        let levelInGroup = level % 100
        var nextLevel = level + 1
        if levelInGroup >= GameViewController.maxLevelNumberPerGroup[group] {
            if group == GameViewController.maxGroupNumber {
                nextLevel = level
            } else {
                nextLevel = (group + 1) * 100
            }
        }
        //if levelStatus(level + 1) != .inaccessible {
        if nextLevel != level && levelStatus(nextLevel) != .inaccessible {
            //level += 1
            level = nextLevel
            nextGameScene = GameSKScene(levelNumber: level)
            nextGameScene!.gameSceneDelegate = self
            closeImagineWindow()
        }
        return nextGameScene
    }
    
    func previousLevelScene() -> GameSKScene? {
        var previousGameScene:GameSKScene? = nil
        let group = level / 100
        let levelInGroup = level % 100
        var previousLevel = level - 1
        if levelInGroup == 0 {
            if group == 0 {
                previousLevel = 0
            } else {
                previousLevel = (group - 1) * 100 + GameViewController.maxLevelNumberPerGroup[group - 1]
            }
        }
        if previousLevel != level && levelStatus(previousLevel) != .inaccessible {
            level = previousLevel // -= 1
            previousGameScene = GameSKScene(levelNumber: level)
            previousGameScene!.gameSceneDelegate = self
            closeImagineWindow()
        }
        return previousGameScene
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowHelp":
                helpViewController = segue.destination as? HelpViewController
                helpViewController!.delegate = self
            case "ShowWorld":
                imagineViewController = segue.destination as? ImagineViewController
                imagineViewController!.delegate = self
            default:
                break
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let positionedScene = sceneView.scene as? PositionedSKScene {
            positionedScene.positionInFrame(size)
        }
        
        if size.width < size.height {
            instructionPortraitBottomConstraint.isActive = true
            imaginePortraitBottomConstraint.isActive = true
        } else {
            instructionPortraitBottomConstraint.isActive = false
            imaginePortraitBottomConstraint.isActive = false
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // Implement GameSceneDelegate
    func isGameCenterEnabled() -> Bool {
        return gcEnabled
    }
    
    func imagine(experience: Experience) {
        if !imagineViewControllerContainer.isHidden {
            imagineViewController?.imagine(experience: experience)
        }
    }
    
    func imagine(experiment: Experiment) {
        if !imagineViewControllerContainer.isHidden {
            imagineViewController?.imagine(experiment: experiment)
        }
    }
    
    func imagine(remoteExperimentNumber: Int) {
        if !imagineViewControllerContainer.isHidden {
            imagineViewController?.imagine(remoteExperimentNumber: remoteExperimentNumber)
        }
    }
    
    func showInstructionWindow() {
        imagineViewControllerContainer.isHidden = true
        imagineViewController?.sceneView.scene = nil
        helpViewController?.displayLevel(level)
        helpViewControllerContainer.isHidden = false
    }
    
    func isInterfaceLocked(_ interface: INTERFACE) -> Bool {
        return interfaceLocks[level / 100][level % 100][interface.rawValue]
    }

    func showImagineWindow(_ gameModel: GameModel0) {
        helpViewControllerContainer.isHidden = true
        if isInterfaceLocked(INTERFACE.level) {
            imagineViewController?.displayLevel(nil, okEnabled: true)
        } else {
            imagineViewController?.displayLevel(gameModel, okEnabled: !isInterfaceLocked(INTERFACE.imagine))
        }
        imagineViewControllerContainer.isHidden = false
    }
    
    func updateImagineWindow(_ gameModel: GameModel0) {
        if imagineViewController != nil {
            if !imagineViewControllerContainer.isHidden && imagineViewController!.imagineModel == nil {
                imagineViewController!.displayLevel(gameModel, okEnabled: !isInterfaceLocked(INTERFACE.imagine))
            }
        }
     }
    
    func showGameCenter() {
        if gcEnabled {
            let gcVC: GKGameCenterViewController = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = GKGameCenterViewControllerState.leaderboards
            gcVC.leaderboardIdentifier = "Level\(level)"
            // GameCenter bug: it must be repeted in completion otherwise it is not working
            //self.present(gcVC, animated: true, completion: {gcVC.leaderboardIdentifier = "Levels";gcVC.leaderboardIdentifier = "Level\(self.level)"})
            self.present(gcVC, animated: true, completion: {})
        } else {
            let alert = UIAlertController(title: "", message: gcLoginMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> () in
                if !self.isInterfaceLocked(INTERFACE.level) {
                    if let scene = self.sceneView.scene as? GameSKScene {
                        scene.tutorNode.gameCenterOk(scene.robotNode, level17ParentNode: scene.topRightNode)
                        if scene.robotNode.recommendation == RECOMMEND.leaderboard {
                            scene.robotNode.recommend(RECOMMEND.done)
                        }
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLevelWindow() {
        helpViewControllerContainer.isHidden = true
        closeImagineWindow()
        if let scene  = sceneView.scene as? GameSKScene {
            if validProducts.count == 0 {
                requestProducts()
            }
            let menuScene = MenuSKScene()
            menuScene.previousGameScene = scene
            menuScene.userDelegate = self
            menuScene.scaleMode = SKSceneScaleMode.aspectFill
            menuScene.displayProducts(validProducts, isPaidTip: paidTip)
            sceneView.presentScene(menuScene, transition: scene.transitionUp)
        }
        if let menuScene  = sceneView.scene as? MenuSKScene {
            sceneView.presentScene(menuScene.previousGameScene!, transition: menuScene.transitionDown)
        }
    }
    func presentMatchMakingViewController() {
        print("Present match making view controller")
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = 2
        matchRequest.maxPlayers = 2
        matchRequest.defaultNumberOfPlayers = 2
        matchRequest.playerGroup = level
        
        let mmvc: GKMatchmakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)!
        mmvc.matchmakerDelegate = self
        self.present(mmvc, animated: true, completion: nil)
    }
    
    func remotePlayerName() -> String? {
        return self.remotePlayerDisplayName
    }

    func sendData(number experiment: Int) {
        print("Send data: \(experiment)")
        if self.match != nil {
            let data = Data(bytes: [UInt8(experiment), UInt8(level)])
            do {
                try self.match?.sendData(toAllPlayers: data, with: GKMatchSendDataMode.reliable)
            } catch {
                print("Error sendind data")
            }
        }
    }
    
    func unlockLevel(_ moves: Int) {
        if gcEnabled {
            let sScore = GKScore(leaderboardIdentifier: "Level\(level)")
            sScore.value = Int64(moves)
            let sLevels = GKScore(leaderboardIdentifier: "Levels")
            sLevels.value = Int64(level)
            // Swift 3 changed NSError to Error
            GKScore.report([sLevels, sScore], withCompletionHandler: { (error: Error?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Score submitted: \(moves) moves in Level \(self.level)")
                }
            })
        }
        
        if isInterfaceLocked(INTERFACE.level) {
            interfaceLocks[level / 100][level % 100][INTERFACE.level.rawValue] = false
            userDefaults.set(interfaceLocks, forKey: unlockDefaultKey)
            //if !imagineViewControllerContainer.hidden {
            //    imagineViewController?.displayLevel(scene.gameModel)
            //}
        }
    }
    
    //Implement MenuSceneDelegate
    func currentLevel() -> Int {
        return level
    }
    
    func updateLevel(_ levelNumber: Int) {
        self.level = levelNumber
    }
    
    func levelStatus(_ level: Int) -> LevelStatus {
        let group = level / 100
        let levelInGroup = level % 100
        if group < 0 || group > GameViewController.maxGroupNumber {
            return .inaccessible
        }
        if !interfaceLocks[group][levelInGroup][INTERFACE.level.rawValue] {
            return .won
        }
        if levelInGroup >= 0 && levelInGroup <= GameViewController.maxLevelNumberPerGroup[group] {
            if levelInGroup == 0 {
                return .accessible
            } else {
                if !interfaceLocks[group][levelInGroup - 1][INTERFACE.level.rawValue] {
                    return .accessible
                }
            }
        }
        return .inaccessible
    }

    // Implement HelpViewControllerDelegate
    func instructionClose() {
        helpViewControllerContainer.isHidden = true
        if let scene = sceneView.scene as? GameSKScene {
            scene.tutorNode.instructionClose(scene.robotNode.instructionButtonNode, level1parentNode: scene.robotNode)
        }
    }
    
    func instructionOk() {
        interfaceLocks[level / 100][level % 100][INTERFACE.instruction.rawValue] = false
        userDefaults.set(interfaceLocks, forKey: unlockDefaultKey)
        if let scene = sceneView.scene as? GameSKScene {
            scene.tutorNode.instructionOk(scene, level1parentNode: scene.robotNode, levelLocked: interfaceLocks[level / 100][level % 100][INTERFACE.level.rawValue], levelLockedNode: scene.robotNode.imagineButtonNode)
            scene.robotNode.instructionButtonNode.disactivate()
            scene.robotNode.instructionButtonNode.unpulse()
            if scene.robotNode.recommendation == RECOMMEND.instruction {
                scene.robotNode.recommend(RECOMMEND.instruction_OK)
            }
            if !isInterfaceLocked(INTERFACE.level) && scene.robotNode.recommendation == RECOMMEND.instruction_OK {
                scene.robotNode.recommend(RECOMMEND.imagine)
            }
        }
        helpViewControllerContainer.isHidden = true
    }
    
    // Implement WorldViewControllerDelegate
    func imagineClose() {
        if !isInterfaceLocked(INTERFACE.level) {
            if let scene = sceneView.scene as? GameSKScene {
                scene.tutorNode.replayClose(scene.robotNode.imagineButtonNode)
            }
        }
        closeImagineWindow()
    }
    
    func closeImagineWindow() {
        imagineViewControllerContainer.isHidden = true
        imagineViewController!.imagineModel = nil
        imagineViewController!.sceneView.scene = nil
    }
    
    func imagineOk() {
        if !isInterfaceLocked(INTERFACE.level) {
            interfaceLocks[level / 100][level % 100][INTERFACE.imagine.rawValue] = false
            userDefaults.set(interfaceLocks, forKey: unlockDefaultKey)
            if let scene = sceneView.scene as? GameSKScene {
                scene.tutorNode.replayOk(scene.robotNode.gameCenterButtonNode)
                scene.robotNode.imagineButtonNode.disactivate()
                if scene.robotNode.recommendation == RECOMMEND.imagine {
                    scene.robotNode.recommend(RECOMMEND.leaderboard)
                }
                if scene.robotNode.recommendation == RECOMMEND.leaderboard && gcEnabled {
                    scene.robotNode.gameCenterButtonNode.pulse()
                }
            }
        }
        closeImagineWindow()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler =
        {
            (ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                //self.presentViewController(ViewController!, animated: true, completion: nil)
                self.gcEnabled = false
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                GKLocalPlayer.localPlayer().unregisterAllListeners()
                GKLocalPlayer.localPlayer().register(self)
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
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        //print(gameCenterViewController.leaderboardIdentifier)
        if let scene = sceneView.scene as? GameSKScene {
            scene.robotNode.gameCenterButtonNode.disactivate()
            scene.tutorNode.gameCenterOk(scene.robotNode, level17ParentNode: scene.topRightNode)
            if isInterfaceLocked(INTERFACE.leaderboard) && !isInterfaceLocked(INTERFACE.level) {
                interfaceLocks[level / 100][level % 100][INTERFACE.leaderboard.rawValue] = false
                //let defaults = UserDefaults.standard
                userDefaults.set(interfaceLocks, forKey: unlockDefaultKey)
            }
            if scene.robotNode.recommendation == RECOMMEND.leaderboard {
                scene.robotNode.recommend(RECOMMEND.done)
            }
        }
    }
    
    func playSound(soundIndex: Int) {
        if !soundDisabled {
            do {
                let nextAudioPlayer: AVAudioPlayer
                nextAudioPlayer = try AVAudioPlayer(contentsOf: soundURLs[soundIndex - 1])
                nextAudioPlayer.prepareToPlay()
                if audioPlayer1 == nil || !audioPlayer1!.isPlaying {
                    audioPlayer1 = nextAudioPlayer
                }
                else if audioPlayer2 == nil || !audioPlayer2!.isPlaying {
                    audioPlayer2 = nextAudioPlayer
                }
                nextAudioPlayer.play()
            } catch {
                print("Error playing sound \(soundIndex)")
            }
        }
    }
    
    func toggleSound() -> Bool {
        soundDisabled = !soundDisabled
        userDefaults.set(soundDisabled, forKey: soundKey)
        return !soundDisabled
    }
    
    func isSoundEnabled() -> Bool {
        return !soundDisabled
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        if let scene = sceneView.scene as? GameSKScene {
            scene.traceNode.dispose(scene.clock)
        }
    }
}
