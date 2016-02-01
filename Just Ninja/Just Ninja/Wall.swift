//
//  Wall.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/1/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import SpriteKit

class Wall: SKSpriteNode {
    
    let WALL_WIDTH: CGFloat = 30.0
    let WALL_HEIGHT: CGFloat = 50.0
    let WALL_COLOR = UIColor.blackColor()
    
    init() {
        super.init(texture: nil, color: WALL_COLOR, size: CGSizeMake(WALL_WIDTH, WALL_HEIGHT))
        
        startMoving()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(-MOVING_SPEED, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
}