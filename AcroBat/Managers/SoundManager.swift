//
//  SoundManager.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import SpriteKit

// TODO: Handle background music
class SoundManager {

    static let shared = SoundManager()

    // Avoid init from outside
    private init() { }

    //    func getSound(_ name: String) -> SKAction { }  // TODO: Implement it!

    let catchBug = SKAction.playSoundFileNamed("CatchBug.wav", waitForCompletion: false)
}
