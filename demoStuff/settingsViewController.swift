//
//  settingsViewController.swift
//  demoStuff
//
//  Created by Abby Jamieson on 11/26/18.
//  Copyright © 2018 Zachary Chucka. All rights reserved.
//

import Foundation
import UIKit

class settingsViewController: UIViewController {
    @IBOutlet var musicSwitch: UISwitch!
    @IBOutlet var segForDiff: UISegmentedControl!
    // prepare to save the settings if save is pressed
    var color: UIColor? = nil
    var music: Bool? = nil
    var diff: String? = nil
    var initialSettings: [String: Any]? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "save" {
                if let secondVC = segue.destination as? mainMenuViewController
                {
                    if color != nil {
                        secondVC.settingsDictionary["theme"] = color
                    }
                    if music != nil {
                        secondVC.settingsDictionary["music"] = music
                    }
                    if diff != nil {
                        secondVC.settingsDictionary["difficulty"] = diff
                    }
                }
            } else if identifier == "cancel" {
                if let secondVC = segue.destination as? mainMenuViewController {
                    // possible need this to send initial values but i will come back to this
                    secondVC.settingsDictionary = initialSettings!
                }
            }
        }
    }
    
    override func viewDidLoad() {
        // update the current settings so that the user knows what he is changing from
        if let m = music {
            if m == false {
                musicSwitch.isOn = false
            }
            // play music in here or not if we want to keep it for the menu
        }
        if let c = color {
            view.backgroundColor = c
        }
        if let d = diff {
            if d != segForDiff.titleForSegment(at: segForDiff.selectedSegmentIndex) {
                segForDiff.selectedSegmentIndex = segForDiff.selectedSegmentIndex + 1 % 2
            }
        }
        initialSettings = ["theme": color!, "difficulty": diff!, "music": music!]
    }
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        color = UIColor.green
        view.backgroundColor = color
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        color = UIColor.cyan
        view.backgroundColor = color
    }
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        color = UIColor.red
        view.backgroundColor = color
    }
    
    @IBAction func switchsPressed(_ sender: UISwitch) {
        music = sender.isOn
    }
    
    @IBAction func diffultySet(_ sender: UISegmentedControl) {
        diff = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
}
