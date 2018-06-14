//
//  Constants.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import Foundation

struct CollisionBitMask {
    static let batCategory: UInt32 = 0x1 << 0
    static let pillarCategory: UInt32 = 0x1 << 1
    static let bugCategory: UInt32 = 0x1 << 2
    static let groundCategory: UInt32 = 0x1 << 3
}
