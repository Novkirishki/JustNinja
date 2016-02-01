//
//  GameScene.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright (c) 2016 Nikolai Novkirishki. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground: Ground!
    var ninja: Ninja!
    var cloudGenerator: CloudGenerator!
    var wallGenerator: WallGenerator!
    
    var isGameStarted = false
    var isGameOver = false
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.00)
        
        addGround()
        addNinja()
        addClouds()
        addWalls()
        addStartLabel()
        addPhysicsWorld()
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
    
    func addStartLabel() {
        let tapToStartLabel = SKLabelNode(text: "Tap to start")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 80
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.blackColor()
        addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
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
        tapToStartLabel?.removeFromParent()
    }
    
    func gameOer() {
        isGameOver = true
        
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
        
        view!.presentScene(newScene)
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
        if isGameOver {
            restart()
        } else if !isGameStarted {
            start()
        } else {
            ninja.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
