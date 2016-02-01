//
//  CloudGenerator.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/1/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import SpriteKit

class CloudGenerator: SKSpriteNode {
    
    let CLOUD_WIDTH: CGFloat = 125.0
    let CLOUD_HEIGHT: CGFloat = 55.0
    
    var generationTimer: NSTimer!
    
    func generateInitialClouds(num: Int) {
        for var i = 0; i < num; i++ {
            let cloud = Cloud(size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT))
            let x = CGFloat(arc4random_uniform(UInt32(size.width))) - size.width / 2
            let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
            cloud.position = CGPointMake(x, y)
            cloud.zPosition = -1
            addChild(cloud)
        }
    }
    
    func startGeneratingCloudsWithSpawnTime(seconds: NSTimeInterval) {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generateCloud", userInfo: nil, repeats: true)
    }
    
    func generateCloud() {
        let x = size.width / 2 + CLOUD_WIDTH / 2
        let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
        let cloud = Cloud(size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT))
        cloud.position = CGPointMake(x, y)
        cloud.zPosition = -1
        addChild(cloud)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
}