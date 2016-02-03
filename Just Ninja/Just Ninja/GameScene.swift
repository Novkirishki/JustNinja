//
//  GameScene.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright (c) 2016 Nikolai Novkirishki. All rights reserved.
//

import SpriteKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    
    var ground: Ground!
    var ninja: Ninja!
    var cloudGenerator: CloudGenerator!
    var wallGenerator: WallGenerator!
    
    var isGameStarted = false
    var isGameOver = false
    
    var currentLevel = 0
    
    let moc = DataController().managedObjectContext
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.00)
        
        addGround()
        addNinja()
        addClouds()
        addWalls()
        addStartLabels()
        addScoreLabels()
        addPhysicsWorld()
        addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        // tap
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view?.addGestureRecognizer(tapRecognizer)
        
        // long press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        self.view?.addGestureRecognizer(longPressRecognizer)
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if !isGameStarted && !isGameOver {
            self.viewController.openHighscores()
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if isGameOver {
            restart()
        } else if !isGameStarted {
            start()
        } else {
            ninja.flip()
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
        let scoreLabel = Score(num: 0)
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
        
        // handle highscores
        saveHighscoreToCD()
        
        // stop all actions
        wallGenerator.stopWalls()
        ninja.fall()
        ground.stop()
        ninja.stop()
        
        // game over label
        let gameOverLabel = SKLabelNode(text: "Game over! Tap to restart")
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 80
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontColor = UIColor.blackColor()
        addChild(gameOverLabel)
        gameOverLabel.runAction(blinkAnimation())
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
