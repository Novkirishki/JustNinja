//
//  WallGenerator.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/1/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import SpriteKit

class WallGenerator: SKSpriteNode {
    
    var generationTimer: NSTimer?
    
    func startGeneratingWallEvery(seconds: NSTimeInterval) {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generateWall", userInfo: nil, repeats: true)
    }
    
    func generateWall() {
        var scale: CGFloat
        let rand = arc4random_uniform(2)
        if rand == 0 {
            scale = -1.0
        } else {
            scale = 1.0
        }
        
        let wall = Wall()
        wall.position.x = size.width/2 + wall.size.width/2
        wall.position.y = scale * (GROUND_HEIGHT / 2 + wall.size.height / 2)
        addChild(wall)
    }
}