//
//  GameElements.swift
//  AcroBat
//
//  Created by Daniele Franzutti on 01/06/18.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let batCategory: UInt32 = 0x1 << 0
    static let pillarCategory: UInt32 = 0x1 << 1
    static let flowerCategory: UInt32 = 0x1 << 2
    static let groundCategory: UInt32 = 0x1 << 3
}

extension GameScene {
    func createBat() -> SKSpriteNode {
        let bat = SKSpriteNode(texture: SKTextureAtlas(named: "Sprites").textureNamed("Bat1"))
        bat.size = CGSize(width: 50, height: 50)
        bat.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bat.physicsBody = SKPhysicsBody(circleOfRadius: bat.size.width / 2)
        bat.physicsBody?.linearDamping = 1.1
        bat.physicsBody?.restitution = 0
        bat.physicsBody?.categoryBitMask = CollisionBitMask.batCategory
        bat.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bat.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        bat.physicsBody?.affectedByGravity = false
        bat.physicsBody?.isDynamic = true
        physicsWorld.gravity = CGVector(dx: 0, dy: 4)

        return bat
    }

    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "Restart")
        restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "Pause")
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }

    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
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

    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore") {
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }

    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "Logo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }

    func createWalls() -> SKNode {
        let flowerNode = SKSpriteNode(imageNamed: "Flower")
        flowerNode.size = CGSize(width: 40, height: 40)
        flowerNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.batCategory
        flowerNode.color = SKColor.blue

        wallPair = SKNode()
        wallPair.name = "wallPair"

        let topWall = SKSpriteNode(imageNamed: "Pillar")
        let btmWall = SKSpriteNode(imageNamed: "Pillar")
        let reSize = CGFloat(max(480 - elapsedSeconds, 400))

        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + reSize)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - reSize)
        topWall.setScale(0.5)
        btmWall.setScale(0.5)

        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.batCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.batCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false

        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.batCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.batCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        topWall.zRotation = CGFloat(Double.pi)

        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.zPosition = 1

        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(flowerNode)
        wallPair.run(moveAndRemove)

        return wallPair
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

}