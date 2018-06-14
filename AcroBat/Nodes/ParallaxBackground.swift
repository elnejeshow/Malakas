//
//  ParallaxBackground.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import SpriteKit

class ParallaxBackground: SKNode {

    var scrollSpeed: CGFloat = 10

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        self.name = "background"
    }

    func setup(by view: SKView) {
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * view.frame.width, y: 0)
            background.name = "layer0"
            background.size = view.bounds.size
            self.addChild(background)
        }
    }

    func updateTime(delta deltaTime: TimeInterval) {

        enumerateChildNodes(withName: "layer0", using: ({
            (node, _) in
            let bg = node as! SKSpriteNode
            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
            if bg.position.x <= -bg.size.width {
                bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
            }
        }))
    }
}
