//
//  GameManager.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import Foundation

// TODO: Make a scene manager
class GameManager {

    static let shared = GameManager()

    // Avoid init from outside
    private init() {
        self.loadGame()
    }

    var score: Int = 0
    var highscore: Int = 0

    func loadGame() {
        if let savedHighscore = UserDefaults.standard.object(forKey: "highscore") {
            print(savedHighscore)
            self.highscore = savedHighscore as! Int
        }
    }

    func saveGame() {
        if let savedHighscore = UserDefaults.standard.object(forKey: "highscore") {
            let savedScore = savedHighscore as! Int
            if self.score > savedScore {
                UserDefaults.standard.set(self.score, forKey: "highscore")
                self.highscore = self.score
            }
        } else {
            UserDefaults.standard.set(self.score, forKey: "highscore")
            self.highscore = self.score
        }
    }

    func resetGame() {
        self.score = 0
    }
}
