//
//  Cloud.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/1/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import SpriteKit

class Cloud: SKShapeNode {
    init(size: CGSize) {
        super.init()
        let path = CGPathCreateWithEllipseInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
        self.path = path
        let cloudColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.70)
        
        fillColor = cloudColor
        glowWidth = 3
        strokeColor = cloudColor
        
        startMoving()
    }    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(-10, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
}