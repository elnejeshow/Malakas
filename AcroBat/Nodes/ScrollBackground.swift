//
//  Background.swift
//  AcroBat
//
//  Created by Walter Purcaro on 17/06/2018.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import SpriteKit


enum ScrollDirection {
    case leftToRight
    case rightToLeft
}


extension SKNode {
    func countChildNodes(withName: String) -> Int {
        var counter = 0
        enumerateChildNodes(withName: withName, using: ({
            (node, _) in counter += 1
        }))
        return counter
    }
}


class ScrollBackground: SKNode {

    var isScrolling: Bool = false

    var scrollSpeed: CGFloat = 1
    var scrollDirection: ScrollDirection = .rightToLeft

    private var size: CGSize = CGSize.zero
    private var textureAtlas = SKTextureAtlas(named: "Backgrounds")

    func addImage(_ name: String) {
        let texture = textureAtlas.textureNamed(name)
        let node = SKSpriteNode(texture: texture)

        node.name = "image"
        node.size = self.size
        node.position = CGPoint(x: CGFloat(self.countChildNodes(withName: "image")) * self.size.width,
                                y: 0)
        node.anchorPoint = CGPoint.zero

        self.addChild(node)
    }

    func addImage(name: String, duplicate: Int) {
        for _ in 0...duplicate { self.addImage(name) }
    }

    convenience init(zPosition: CGFloat, scrollDirection: ScrollDirection, scrollSpeed: CGFloat) {
        self.init()

        self.zPosition = zPosition
        self.scrollDirection = scrollDirection
        self.scrollSpeed = scrollSpeed
    }

    func setup(by view: SKView) {
        self.size = view.bounds.size
        //TODO: Erase all children and rebuild
    }

    func startScrolling() {
        self.isScrolling = true
    }

    func updatePosition(distance: CGFloat) {
        //TODO: If reaches end of the loop stop scrolling
        if !self.isScrolling { return }

        if self.scrollDirection == .rightToLeft {
            self.position.x -= distance * self.scrollSpeed
        }
        else {
            self.position.x += distance * self.scrollSpeed
        }
    }

}
