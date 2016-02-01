//
//  GameScene.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright (c) 2016 Nikolai Novkirishki. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var ground: Ground!
    var ninja: Ninja!
    var cloudGenerator: CloudGenerator!
    
    var isGameStarted = false
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.00)
        
        // ground
        ground = Ground(size: CGSizeMake(view.frame.width, GROUND_HEIGHT))
        ground.position = CGPointMake(0, view.frame.size.height/2)
        addChild(ground)
        
        // ninja
        ninja = Ninja()
        ninja.position = CGPointMake(70, ground.position.y + ground.frame.size.height/2 + ninja.frame.size.height/2)
        addChild(ninja)
        ninja.breathe()
        
        // clouds
        cloudGenerator = CloudGenerator(color: UIColor.clearColor(), size: view.frame.size)
        cloudGenerator.position = view.center
        addChild(cloudGenerator)
        cloudGenerator.generateInitialClouds(5)
        cloudGenerator.startGeneratingCloudsWithSpawnTime(5)
    }
    
    func start() {
        isGameStarted = true
        ninja.stop()
        ninja.startRunning()
        ground.start()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isGameStarted {
            start()
        } else {
            ninja.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
