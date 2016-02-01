//
//  Score.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/1/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Score: SKLabelNode {
    
    var number = 0
    
    init(num: Int) {
        super.init()
    
        fontColor = UIColor.blackColor()
        fontName = "Helvetica"
        
        number = num
        text = "\(num)"
    }
    
    func increaseScore() {
        number++
        text = "\(number)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}