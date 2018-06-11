//
//  GameScene.swift
//  AcroBat
//
//  Created by Daniele Franzutti on 01/06/18.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import SpriteKit
//import URWeatherView

class GameScene: SKScene, SKPhysicsContactDelegate {

    var bgScroller: InfiniteScrollingBackground?
    var fgScroller: InfiniteScrollingBackground?
    var gScroller: InfiniteScrollingBackground?

    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0

    var forwardToggle = false
    var _firstStart = true
    var _startTime = TimeInterval()
    var elapsedSeconds: Int = 0
    var gameStarted = Bool(false)
    var died = Bool(false)
    let collectSound = SKAction.playSoundFileNamed("CollectSound.wav", waitForCompletion: false)
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
    let batAtlas = SKTextureAtlas(named: "Sprites")
    var batSprites = Array<SKTexture>()
    var bat = SKSpriteNode()
    var repeatActionbat = SKAction()

    func createSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)

        addChild(topSky)
        addChild(bottomSky)

        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }

    override func didMove(to view: SKView) {
        createScene()
//        let weatherView = URWeatherView(frame: view.bounds)
//        weatherView.initView(mainWeatherImage: UIImage(named: "Background")!, backgroundImage: UIImage())
//        let weather: URWeatherType = .comet
//        weatherView.startWeatherSceneBulk(weather, debugOption: true)
//        self.view?.addSubview(weatherView)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            bgScroller?.isPaused = false
            fgScroller?.isPaused = false
            gScroller?.isPaused = false

            gameStarted =  true
            bat.physicsBody?.affectedByGravity = true
            createPauseBtn()
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            self.bat.run(repeatActionbat)

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

            bat.physicsBody?.velocity = CGVector(dx: 5, dy: 5)
            bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -40))

            self.run(spawnDelayForever)

        } else {
            if died == false {
                bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -40))
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
                        pauseBtn.texture = SKTexture(imageNamed: "Play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "Pause")
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
        self.physicsBody?.collisionBitMask = CollisionBitMask.batCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.batCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false

        self.physicsWorld.contactDelegate = self

//        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        createSky()

        // Getting the images:
        let bgImages = [UIImage(named: "SummerBackground")!, UIImage(named: "SummerBackground")!]
        let fgImages = [UIImage(named: "SummerForeground")!, UIImage(named: "SummerForeground")!]
        let gImages = [UIImage(named: "SummerGround")!, UIImage(named: "SummerGround")!]

        // Initializing InfiniteScrollingBackground's Instance:
        bgScroller = InfiniteScrollingBackground(images: bgImages, scene: self, scrollDirection: .left, speed: 18)
        fgScroller = InfiniteScrollingBackground(images: fgImages, scene: self, scrollDirection: .left, speed: 9)
        gScroller = InfiniteScrollingBackground(images: gImages, scene: self, scrollDirection: .left, speed: 7)

        bgScroller?.isPaused = true
        fgScroller?.isPaused = true
        gScroller?.isPaused = true

        bgScroller?.scroll()
        fgScroller?.scroll()
        gScroller?.scroll()

        // (Optional) Changing the instance's zPosition:
        //bgScroller?.zPosition = -10
        //fgScroller?.zPosition = -1

//        for i in 0..<2 {
//            let background = SKSpriteNode(imageNamed: "Background")
//            background.anchorPoint = CGPoint.init(x: 0, y: 0)
//            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
//            background.name = "background"
//            background.size = (self.view?.bounds.size)!
//            self.addChild(background)
//        }

        //SET UP THE BIRD SPRITES FOR ANIMATION
        batSprites.append(batAtlas.textureNamed("Bat1"))
        batSprites.append(batAtlas.textureNamed("Bat2"))
        batSprites.append(batAtlas.textureNamed("Bat3"))
        batSprites.append(batAtlas.textureNamed("Bat4"))
        batSprites.append(batAtlas.textureNamed("Bat5"))
        batSprites.append(batAtlas.textureNamed("Bat6"))
        batSprites.append(batAtlas.textureNamed("Bat7"))
        batSprites.append(batAtlas.textureNamed("Bat8"))

        self.bat = createBat()
        self.addChild(bat)

        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animatebat = SKAction.animate(with: self.batSprites, timePerFrame: 0.1)
        self.repeatActionbat = SKAction.repeatForever(animatebat)

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

      if firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory || firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, _) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false {
                died = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bat.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.batCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(collectSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.batCategory {
            run(collectSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }

        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime

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
//                enumerateChildNodes(withName: "background", using: ({
//                    (node, _) in
//                    let bg = node as! SKSpriteNode
//                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
//                    if bg.position.x <= -bg.size.width {
//                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
//                    }
//                }))
            }
        }
    }
}
