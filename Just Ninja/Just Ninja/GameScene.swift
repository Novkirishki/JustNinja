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
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.00)
        
        ground = Ground(size: CGSizeMake(view.frame.width, 20))
        ground.position = CGPointMake(0, view.frame.size.height/2)
        addChild(ground)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       ground.start()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
