//
//  HUD.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import SpriteKit

class HUD: SKNode {

    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()

    var score: Int {
        get {
            return GameManager.shared.score
        }
        set {
            GameManager.shared.score = newValue
            self.scoreLbl.text = "\(GameManager.shared.score)"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        self.name = "hud"
    }

    func setup(by view: SKView) {
        scoreLbl = createScoreLabel(to: view.frame)
        self.addChild(scoreLbl)

        highscoreLbl = createHighscoreLabel(to: view.frame)
        self.addChild(highscoreLbl)

        createLogo(to: view.frame)

        taptoplayLbl = createTaptoplayLabel(to: view.frame)
        self.addChild(taptoplayLbl)
    }

    func createRestartBtn(to frame: CGRect) {
        restartBtn = SKSpriteNode(imageNamed: "Restart")
        restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createPauseBtn(to frame: CGRect) {
        pauseBtn = SKSpriteNode(imageNamed: "Pause")
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }

    func createScoreLabel(to frame: CGRect) -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: frame.width / 2, y: frame.height / 2 + frame.height / 2.6)
        scoreLbl.text = "\(GameManager.shared.score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }

    func createHighscoreLabel(to frame: CGRect) -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: frame.width - 80, y: frame.height - 22)

        highscoreLbl.text = "Highest Score: \(GameManager.shared.highscore)"
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"

        return highscoreLbl
    }

    func createLogo(to frame: CGRect) {
        logoImg = SKSpriteNode(imageNamed: "Logo")
        logoImg.size = CGSize(width: 300, height: 125)
        logoImg.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createTaptoplayLabel(to frame: CGRect) -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }

}
