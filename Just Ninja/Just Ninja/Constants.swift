//
//  Constants.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Foundation
import UIKit

let GROUND_HEIGHT: CGFloat = 20.0
let NINJA_HEIGHT: CGFloat = 44
let NINJA_WIDTH: CGFloat = 32
let WALL_WIDTH: CGFloat = 30.0
let WALL_HEIGHT: CGFloat = 50.0

let MOVING_SPEED: CGFloat = 320.0
let WALLS_PER_LEVEL = 7
let WALLS_GENERATE_INTERVALS_PER_LEVEL: [NSTimeInterval] = [1.0, 0.8, 0.6, 0.5, 0.4, 0.3]
let MAX_LEVEL: Int = 5

let NINJA_CATEGORY: UInt32 = 0x1 << 0
let WALL_CATEGORY: UInt32 = 0x1 << 1