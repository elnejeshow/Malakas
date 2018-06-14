//
//  GameScene.swift
//  AcroBat
//
//  Created by Daniele Franzutti on 01/06/18.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var wallPair = SKNode()
    var moveAndRemove = SKAction()

    //CREATE THE BAT ATLAS FOR ANIMATION
    let batAtlas = SKTextureAtlas(named: "Sprites")
    var batSprites = [SKTexture]()
    var repeatActionbat = SKAction()

    var deltaTime: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0

    var gameRunning = Bool(false)
    var playerDied = Bool(false)

    var background = ParallaxBackground()
    var player = Bat(name: "player", size: CGSize(width: 75, height: 75))
    var hud = HUD()

    override func sceneDidLoad() {
        self.setupPhysics()
    }

    override func didMove(to view: SKView) {
        self.setupScene(by: view)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchDown(atPoint: touch.location(in: self))
    }

    override func update(_ currentTime: TimeInterval) {
        if self.gameRunning == false || self.playerDied == true { return }

        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }

        self.deltaTime = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime

        self.background.updateTime(delta: self.deltaTime)
    }

    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody!.collisionBitMask = CollisionBitMask.batCategory
        self.physicsBody!.contactTestBitMask = CollisionBitMask.batCategory
        self.physicsBody!.isDynamic = false
        self.physicsBody!.affectedByGravity = false

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 5)
        self.physicsWorld.contactDelegate = self
    }

    func setupScene(by view: SKView) {
        // TODO: Colorize background of Background node as well
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)

        self.background.setup(by: view)
        self.addChild(self.background)

        self.player.setup(by: view)  // TODO: Change/scale the size according the view
        self.player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.player)

        self.hud.setup(by: view)
        self.addChild(self.hud)

        //SET UP THE BAT SPRITES FOR ANIMATION
        batSprites.append(batAtlas.textureNamed("Bat1"))
        batSprites.append(batAtlas.textureNamed("Bat2"))
        batSprites.append(batAtlas.textureNamed("Bat3"))
        batSprites.append(batAtlas.textureNamed("Bat4"))
        batSprites.append(batAtlas.textureNamed("Bat5"))
        batSprites.append(batAtlas.textureNamed("Bat6"))
        batSprites.append(batAtlas.textureNamed("Bat7"))
        batSprites.append(batAtlas.textureNamed("Bat8"))

        //ANIMATE THE BAT AND REPEAT THE ANIMATION FOREVER
        let animatebat = SKAction.animate(with: self.batSprites, timePerFrame: 0.1)
        self.repeatActionbat = SKAction.repeatForever(animatebat)
    }

    func touchDown(atPoint position: CGPoint) {
        if gameRunning == false {

            gameRunning = true
            self.player.physicsBody?.affectedByGravity = true
            self.hud.createPauseBtn(to: self.view!.frame)  // NOTE: Bad frame request here
            self.hud.logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.hud.logoImg.removeFromParent()
            })
            self.hud.taptoplayLbl.removeFromParent()
            self.player.run(repeatActionbat)

            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })

            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])

            self.player.physicsBody?.velocity = CGVector(dx: 5, dy: 5)
            self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -40))

            self.run(spawnDelayForever)

        } else {
            if playerDied == false {
                self.player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -40))
            }
        }

        if playerDied == true {
            if self.hud.restartBtn.contains(position) {
                GameManager.shared.saveGame()
                restartScene()
            }
        } else {
            if self.hud.pauseBtn.contains(position) {
                if self.isPaused == false {
                    self.isPaused = true
                    self.hud.pauseBtn.texture = SKTexture(imageNamed: "Play")
                } else {
                    self.isPaused = false
                    self.hud.pauseBtn.texture = SKTexture(imageNamed: "Pause")
                }
            }
        }
    }

    // TODO: Move to the scene manager
    func restartScene() {
        GameManager.shared.resetGame()
        let scene = GameScene(size: self.view!.bounds.size)
        self.view!.presentScene(scene)
    }

}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory || firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, _) in
                node.speed = 0
                self.removeAllActions()
            }))
            if playerDied == false {
                playerDied = true
                self.hud.createRestartBtn(to: self.view!.frame)  // NOTE: Bad frame request here
                self.hud.pauseBtn.removeFromParent()
                self.player.removeAllActions()
            }

        } else if firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.bugCategory {
            run(SoundManager.shared.catchBug)
            self.hud.score += 1
            secondBody.node?.removeFromParent()

        } else if firstBody.categoryBitMask == CollisionBitMask.bugCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory {
            run(SoundManager.shared.catchBug)
            self.hud.score += 1
            firstBody.node?.removeFromParent()
        }
    }
}

// TODO: Rewrite it!
extension GameScene {

    func createWalls() -> SKNode {
        let bugNode = SKSpriteNode(imageNamed: "Bug")
        bugNode.size = CGSize(width: 56, height: 37)
        bugNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        bugNode.physicsBody = SKPhysicsBody(texture: bugNode.texture!, size: bugNode.size)
        bugNode.physicsBody?.affectedByGravity = false
        bugNode.physicsBody?.isDynamic = false
        bugNode.physicsBody?.categoryBitMask = CollisionBitMask.bugCategory
        bugNode.physicsBody?.collisionBitMask = 0
        bugNode.physicsBody?.contactTestBitMask = CollisionBitMask.batCategory
        bugNode.color = SKColor.blue

        wallPair = SKNode()
        wallPair.name = "wallPair"

        let topWall = SKSpriteNode(imageNamed: "Pillar")
        let btmWall = SKSpriteNode(imageNamed: "Pillar")
        let reSize = CGFloat(max(480 - Int(deltaTime), 400))

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
        wallPair.addChild(bugNode)
        wallPair.run(moveAndRemove)

        return wallPair
    }

}
