//
//  GameViewController.swift
//  demoStuff
//
//  Created by Abby Jamieson on 11/26/18.
//  Copyright © 2018 Zachary Chucka. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var highScore: Int = 0
    var theme: UIColor = UIColor.cyan
    var time: Int = -1
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "gameOver" {
                if let destin = segue.destination as? gameOverViewController {
                    destin.finalValue = self.time
                    destin.highValue = self.highScore
                    destin.theme = self.theme
                }
            }
        }
    }
    
}
