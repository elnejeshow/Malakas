//
//  GameViewController.swift
//  AcroBat
//
//  Created by Daniele Franzutti on 01/06/18.
//  Copyright © 2018 Daniele Franzutti. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create view
        guard let view = self.view as! SKView? else { return }

        let scene = GameScene(size: view.bounds.size)  // view.frame.size

        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill

        // Debug
        view.showsFPS = true
        view.showsNodeCount = false
        view.ignoresSiblingOrder = false
        view.showsPhysics = true

        // Present the scene
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
