//
//  ParallaxBackground.swift
//  AcroBat
//
//  Created by Walter Purcaro on 18/06/2018.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import SpriteKit

class ParallaxBackground: SKNode {

    var scrollSpeedFactor: CGFloat = 0.08

    private var size: CGSize = CGSize.zero

    private var _scrollDirection: ScrollDirection = .rightToLeft
    var scrollDirection: ScrollDirection {
        get {
            return self._scrollDirection
        }
        set {
            self._scrollDirection = newValue

            enumerateChildNodes(withName: "background", using: ({
                (node, _) in
                let bg = node as! ScrollBackground
                bg.scrollDirection = newValue
            }))
        }
    }

    private var _isScrolling = false
    var isScrolling: Bool {
        get {
            return self._isScrolling
        }
        set {
            self._isScrolling = newValue

            enumerateChildNodes(withName: "background", using: ({
                (node, _) in
                let bg = node as! ScrollBackground
                bg.isScrolling = newValue
            }))
        }
    }

    convenience init(scrollSpeedFactor: CGFloat) {
        self.init()
        self.scrollSpeedFactor = scrollSpeedFactor
    }

//    func addBackgrounds(withImageNames: [String]) {
//        let bg = self.addBackground()
//        for imageName in withImageNames { bg.addImage(imageName) }
//    }

    func addLayer() -> ScrollBackground {
        let background = ScrollBackground(zPosition: -1, scrollDirection: self.scrollDirection, scrollSpeed: 1)
        background.name = "background"

        enumerateChildNodes(withName: "background", using: ({
            (node, _) in
            let bg = node as! ScrollBackground
            bg.zPosition -= 1
            bg.scrollSpeed -= self.scrollSpeedFactor * -bg.zPosition
            print(bg.scrollSpeed)
        }))

        self.addChild(background)
        return background
    }

    func setup(by view: SKView) {
        self.size = view.bounds.size

//        enumerateChildNodes(withName: "background", using: ({
//            (node, _) in
//            let bg = node as! ScrollBackground
//            bg.setup(by: view)
//        }))
    }

    func startScrolling() {
        self.isScrolling = true
    }

    func updatePosition(distance: CGFloat) {
        if !self.isScrolling { return }

        enumerateChildNodes(withName: "background", using: ({
            (node, _) in
            let bg = node as! ScrollBackground
            bg.updatePosition(distance: distance)
        }))
    }

}
