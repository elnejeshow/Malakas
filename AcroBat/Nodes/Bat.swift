//
//  Bat.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import SpriteKit

class Bat: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(name: String, size: CGSize) {
        let texture = SKTextureAtlas(named: "Sprites").textureNamed("Bat1")
        super.init(texture: texture, color: .clear, size: size)
        self.name = name
    }

    func setup(by view: SKView) {
        self.setupPhysics()
    }

    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.5)
        self.physicsBody?.linearDamping = 1.1
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = CollisionBitMask.batCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.bugCategory | CollisionBitMask.groundCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
    }

}
