//
//  gameOverViewController.swift
//  demoStuff
//
//  Created by Abby Jamieson on 11/26/18.
//  Copyright © 2018 Zachary Chucka. All rights reserved.
//

import Foundation
import UIKit

class gameOverViewController: UIViewController {
    @IBOutlet var finalScore: UILabel!
    @IBOutlet var highScore: UILabel!
    var finalValue: Int = 0
    var highValue: Int = 0
    var theme: UIColor = UIColor.cyan
    var diff: String = ""
    var music: Bool = false
    
    override func viewDidLoad() {
        // add in the users score along with the high score
        // if user breaks the high score, maybe give them a nice little high score greeting
        // determine if the user's score is good enough to be added to the leaderboards
        // connect once I realize how to with the way that the spritekit works
        self.view.backgroundColor = theme
        if finalValue < highValue
        {
            finalScore.text = "Your Score: \(finalValue)"
            highScore.text = "New High Score!"
        } else {
            finalScore.text = "Your Score: \(finalValue)"
            highScore.text = "High Score: \(highValue)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "mainMenu" {
                if let desty = segue.destination as? mainMenuViewController {
                    desty.newHigh = finalValue
                    desty.settingsDictionary["theme"] = theme
                    desty.settingsDictionary["difficulty"] = diff
                    desty.settingsDictionary["music"] = music
                }
            }
        }
    }
}
