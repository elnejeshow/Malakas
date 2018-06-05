//
//  GameScene.swift
//  Malakas
//
//  Created by Daniele Franzutti on 01/06/18.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var forwardToggle = false
    var _firstStart = true
    var _startTime = TimeInterval()
    var elapsedSeconds: Int = 0
    var gameStarted = Bool(false)
    var died = Bool(false)
    let collectSound = SKAction.playSoundFileNamed("collectSound.wav", waitForCompletion: false)
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()

    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named: "Sprites")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()

    override func didMove(to view: SKView) {
        createScene()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            gameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            self.bird.run(repeatActionbird)

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

            bird.physicsBody?.velocity = CGVector(dx: 5, dy: 5)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -30))

            self.run(spawnDelayForever)

        } else {
            if died == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -30))
            }
        }

        for touch in touches {
            let location = touch.location(in: self)
            if died == true {
                if restartBtn.contains(location) {
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)! {
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                if pauseBtn.contains(location) {
                    if self.isPaused == false {
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }

    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }

    func createScene() {
        self._firstStart = true

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false

        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)

        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }

        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        birdSprites.append(birdAtlas.textureNamed("bird5"))
        birdSprites.append(birdAtlas.textureNamed("bird6"))
        birdSprites.append(birdAtlas.textureNamed("bird7"))
        birdSprites.append(birdAtlas.textureNamed("bird8"))

        self.bird = createBird()
        self.addChild(bird)

        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animatebird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionbird = SKAction.repeatForever(animatebird)

        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)

        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)

        createLogo()

        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

      if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, _) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false {
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(collectSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(collectSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if _firstStart {
            self._startTime = currentTime
            _firstStart = false
        } else {
            self.elapsedSeconds = Int(currentTime - _startTime)
            //            print(elapsedSeconds)
        }

        // Called before each frame is rendered
        if gameStarted == true {
            if died == false {
                enumerateChildNodes(withName: "background", using: ({
                    (node, _) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                }))
            }
        }
    }
}
