//
//  zPosition_enum.swift
//  infinite_runner
//
//  Created by macos on 7.09.2021.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import SwiftUI


enum zPositions {
    
    static let background: CGFloat = 0
    static let bullet: CGFloat = 1
    static let player: CGFloat = 2
    static let enemy: CGFloat = 3
}

enum playerStartingPosition {
    
    static let xMultiplier: CGFloat = 0.5
    static let yMultiplier: CGFloat = 0.2
}

enum bulletConstants {
    
    static let reAttackTime = 0.15
    
    enum direction {
        case up
        case down
    }
}
