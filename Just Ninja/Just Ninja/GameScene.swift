//
//  GameScene.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright (c) 2016 Nikolai Novkirishki. All rights reserved.
//

import SpriteKit
import CoreData
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    var ground: Ground!
    var ninja: Ninja!
    var cloudGenerator: CloudGenerator!
    var wallGenerator: WallGenerator!
    var isGameStarted = false
    var isGameOver = false
    var currentLevel = 0
    var scoreLabel: Score!
    var backgroundMusicPlayer: AVAudioPlayer?
    var bumbMusicPlayer: AVAudioPlayer?
    
    let moc = DataController().managedObjectContext
    
    override func didMoveToView(view: SKView) {
        
        addBackground()
        addGround()
        addNinja()
        addClouds()
        addWalls()
        addStartLabels()
        addScoreLabels()
        addPhysicsWorld()
        addGestureRecognizers()
        setSounds()
    }
    
    func setSounds() {
        let backgroundMusicPath = NSBundle.mainBundle().pathForResource("background", ofType: "mp3")
        let bgMusicURL = NSURL.fileURLWithPath(backgroundMusicPath!)
        
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL)
        } catch {
            print("Player not available")
        }
        
        let bumpSoundPath = NSBundle.mainBundle().pathForResource("bump", ofType: "wav")
        let bumpSoundUrl = NSURL.fileURLWithPath(bumpSoundPath!)
        
        do {
            try bumbMusicPlayer = AVAudioPlayer(contentsOfURL: bumpSoundUrl)
        } catch {
            print("Player not available")
        }
        
        backgroundMusicPlayer?.volume = 0.7
        backgroundMusicPlayer?.play()
    }
    
    func addBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background0.png")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: view!.frame.size)
        backgroundImage.position = view!.center
        backgroundImage.zPosition = -10
        addChild(backgroundImage)
    }
    
    func addGestureRecognizers() {
        // tap
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view?.addGestureRecognizer(tapRecognizer)
        
        // long press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.view?.addGestureRecognizer(longPressRecognizer)
        
        // swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view?.addGestureRecognizer(swipeDown)
        
        // double tap
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if !isGameStarted && !isGameOver {
            self.viewController.openHighscores(scoreLabel.text)
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if !isGameStarted && !isGameOver {
            start()
        } else if isGameStarted {
            ninja.flip()
        }
    }
    
    func handleSwipe(gestureRecognizer: UIGestureRecognizer) {
        if isGameOver {
            self.viewController.openHighscores(scoreLabel.text)
        }
    }
    
    func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        if isGameOver {
            restart()
        }
    }
    
    func addGround() {
        ground = Ground(size: CGSizeMake(view!.frame.width, GROUND_HEIGHT))
        ground.position = CGPointMake(0, view!.frame.size.height/2)
        addChild(ground)
    }
    
    func addNinja() {
        ninja = Ninja()
        ninja.position = CGPointMake(70, ground.position.y + ground.frame.size.height/2 + ninja.frame.size.height/2)
        addChild(ninja)
        ninja.breathe()
    }
    
    func addClouds() {
        cloudGenerator = CloudGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        cloudGenerator.position = view!.center
        addChild(cloudGenerator)
        cloudGenerator.generateInitialClouds(5)
        cloudGenerator.startGeneratingCloudsWithSpawnTime(5)
    }
    
    func addWalls() {
        wallGenerator = WallGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        wallGenerator.position = view!.center
        addChild(wallGenerator)
    }
    
    func addStartLabels() {
        let tapToStartLabel = SKLabelNode(text: "Tap to start")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 80
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.blackColor()
        addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
        
        let longPressToHighscoresLabel = SKLabelNode(text: "Long press to view scores")
        longPressToHighscoresLabel.name = "longPressToHighscoresLabel"
        longPressToHighscoresLabel.position.x = view!.center.x
        longPressToHighscoresLabel.position.y = view!.center.y - 80
        longPressToHighscoresLabel.fontName = "Helvetica"
        longPressToHighscoresLabel.fontColor = UIColor.blackColor()
        addChild(longPressToHighscoresLabel)
        longPressToHighscoresLabel.runAction(blinkAnimation())
    }
    
    func addScoreLabels() {
        scoreLabel = Score(num: 0)
        scoreLabel.name = "scoreLabel"
        scoreLabel.position = CGPointMake(view!.frame.size.width - 25, view!.frame.size.height - 35)
        addChild(scoreLabel)
        
        let currentHighscore = getHighscoreFromCD()
        let highscoreLabel = Score(num: currentHighscore)
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPointMake(25, view!.frame.size.height - 35)
        addChild(highscoreLabel)
        
        let highscoreTextLabel = SKLabelNode(text: "High")
        highscoreTextLabel.fontSize = 18.0
        highscoreTextLabel.fontColor = UIColor.blackColor()
        highscoreTextLabel.fontName = "Helvetica"
        highscoreTextLabel.position = CGPointMake(0, -20)
        highscoreLabel.addChild(highscoreTextLabel)
    }
    
    func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    func start() {
        isGameStarted = true
        ninja.stop()
        ninja.startRunning()
        ground.start()
        wallGenerator.startGeneratingWallEvery(1)
        
        let tapToStartLabel = childNodeWithName("tapToStartLabel")
        let longPressToHighscoresLabel = childNodeWithName("longPressToHighscoresLabel")
        tapToStartLabel?.removeFromParent()
        longPressToHighscoresLabel?.removeFromParent()
    }
    
    func gameOer() {
        isGameOver = true
        bumbMusicPlayer?.play()
        
        // handle highscores
        saveHighscoreToCD()
        
        // stop all actions
        backgroundMusicPlayer?.stop()
        wallGenerator.stopWalls()
        ninja.fall()
        ground.stop()
        ninja.stop()
        
        addGameOverLabels()
    }
    
    func addGameOverLabels() {
        let gameOverLabel = SKLabelNode(text: "Game over! Double tap to restart")
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 80
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontColor = UIColor.blackColor()
        addChild(gameOverLabel)
        gameOverLabel.runAction(blinkAnimation())
        
        let swipeToSaveHighscore = SKLabelNode(text: "Swipe to save score")
        swipeToSaveHighscore.name = "swipeToSaveHighscore"
        swipeToSaveHighscore.position.x = view!.center.x
        swipeToSaveHighscore.position.y = view!.center.y - 80
        swipeToSaveHighscore.fontName = "Helvetica"
        swipeToSaveHighscore.fontColor = UIColor.blackColor()
        addChild(swipeToSaveHighscore)
        swipeToSaveHighscore.runAction(blinkAnimation())
    }
    
    func restart() {
        cloudGenerator.stopGenerating()
        
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        newScene.viewController = self.viewController
        
        view!.presentScene(newScene)
    }
    
    func saveHighscoreToCD() {
        let scoreLabel = childNodeWithName("scoreLabel") as! Score
        
        let currentMaxScore = getHighscoreFromCD()
        
        if currentMaxScore < scoreLabel.number {
            let highscoreFetch = NSFetchRequest(entityName: "Highscore")
            
            do {
                let fetchedHighscore = try moc.executeFetchRequest(highscoreFetch) as! [Highscore]
                if fetchedHighscore.count == 0 {
                    let entity = NSEntityDescription.insertNewObjectForEntityForName("Highscore", inManagedObjectContext: moc) as! Highscore
                    entity.setValue(scoreLabel.number, forKey: "points")
                    
                    do {
                        try moc.save()
                    } catch {
                        fatalError("failed to save highscore: \(error)")
                    }
                } else {
                    let managedHighscore = fetchedHighscore[0]
                    managedHighscore.setValue(scoreLabel.number, forKey: "points")
                    do {
                        try moc.save()
                    } catch {
                        fatalError("failed to save highscore: \(error)")
                    }
                }
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    func getHighscoreFromCD() -> Int {
        let highscoreFetch = NSFetchRequest(entityName: "Highscore")
        
        do {
            let fetchedHighscore = try moc.executeFetchRequest(highscoreFetch) as! [Highscore]
            if fetchedHighscore.count != 0 {
                return fetchedHighscore.first!.points!.integerValue
            }
        } catch {
            fatalError("\(error)")
        }
        
        return 0
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGameOver {
            gameOer()
        }
    }
    
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeIn, fadeOut])
        return SKAction.repeatActionForever(blink)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        if wallGenerator.wallsTracker.count > 0 {
            let wall = wallGenerator.wallsTracker[0] as Wall
            
            let wallLocation = wallGenerator.convertPoint(wall.position, toNode: self)
            if wallLocation.x < ninja.position.x {
                wallGenerator.wallsTracker.removeAtIndex(0)
                
                let scoreLabel = childNodeWithName("scoreLabel") as! Score
                scoreLabel.increaseScore()
                
                if scoreLabel.number % WALLS_PER_LEVEL == 0 {
                    if currentLevel < MAX_LEVEL {
                        currentLevel++
                        
                        wallGenerator.stopGeneratingWalls()
                        wallGenerator.startGeneratingWallEvery(WALLS_GENERATE_INTERVALS_PER_LEVEL[currentLevel])
                    }
                }
            }
        }
    }
}
