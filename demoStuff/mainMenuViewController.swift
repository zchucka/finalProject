//
//  mainMenuViewController.swift
//  demoStuff
//
//  Created by Abby Jamieson on 11/26/18.
//  Copyright © 2018 Zachary Chucka. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class mainMenuViewController: UIViewController {
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var secondBestLabel: UILabel!
    @IBOutlet var thirdBestLabel: UILabel!
    @IBOutlet var fourthBestLabel: UILabel!
    @IBOutlet var fifthBestLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scoresArray = [HighScore]()
    var settingsDictionary: [String: Any] = ["theme": UIColor.cyan, "music": false, "difficulty": "Easy"]
    var newHigh: Int? = nil
    
    override func viewDidLoad() {
        view.backgroundColor = (settingsDictionary["theme"] as! UIColor)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(documentsDirectory)
        loadScores()
    }
    
    func saveScores() {
        //this method will write the changes we have made to our context to disk (SQLite database)
        // try to save the context
        do {
            try context.save() // like a git commit
        }
        catch {
            print("error saving scores")
        }
    }
    
    func loadScores() {
        let request: NSFetchRequest<HighScore> = HighScore.fetchRequest()
        
        do {
            scoresArray = try context.fetch(request)
            //cleanse() // ***if i need to clean up core data***
            if scoresArray.count < 5 {
                initializeScores()
            }
            if let newScore = newHigh
            {
                newHighScore(userScore: Int32(newScore))
            }
            //newHighScore(userScore: 12) //***for testing adding***
            sortArray(startIndex: 0)
            highScoreLabel.text = "1. \(scoresArray[0].score) seconds"
            secondBestLabel.text = "2. \(scoresArray[1].score) seconds"
            thirdBestLabel.text = "3. \(scoresArray[2].score) seconds"
            fourthBestLabel.text = "4. \(scoresArray[3].score) seconds"
            fifthBestLabel.text = "5. \(scoresArray[4].score) seconds"
        }
        catch {
            print("Error fetching requests")
        }
    }
    
    func initializeScores() {
        var x = 0
        while x < 5
        {
            let newScore = HighScore(context: self.context)
            newScore.score = Int32(50 - ((5-x) * 5))
            newScore.position = Int16(x + 1)
            scoresArray.append(newScore)
            x += 1
        }
        saveScores()
    }
    
    // when I want to delete the entire score array
    func cleanse() {
        var x = scoresArray.count - 1
        while x >= 0
        {
            context.delete(scoresArray[x])
            scoresArray.remove(at: x)
            x -= 1
        }
        saveScores()
    }
    
    func sortArray(startIndex: Int) {
        var x = startIndex
        while x < scoresArray.count {
            if scoresArray[x].position == startIndex + 1 && x != startIndex
            {
                swapSpots(first: startIndex, second: x)
            }
            x += 1
        }
        if (startIndex < scoresArray.count - 1) {
            sortArray(startIndex: startIndex + 1)
        }
    }
    
    func newHighScore(userScore: Int32) {
        let newScore = HighScore(context: self.context)
        newScore.score = userScore
        newScore.position = 6
        for x in scoresArray {
            if x.score > userScore && newScore.position > x.position {
                newScore.position = x.position
                x.position += 1
            } else if x.score > userScore {
                x.position += 1
            }
        }
        scoresArray.append(newScore)
        
        var y = 0
        while y < scoresArray.count {
            if scoresArray[y].position == 6 {
                context.delete(scoresArray[y])
                scoresArray.remove(at: y)
            }
            y += 1
        }
        saveScores()
    }
    
    func swapSpots(first: Int, second: Int) {
        let tempPos = scoresArray[first].position
        let tempScore = scoresArray[first].score
        
        scoresArray[first].position = scoresArray[second].position
        scoresArray[first].score = scoresArray[second].score
        
        scoresArray[second].position = tempPos
        scoresArray[second].score = tempScore
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier
        {
            if identifier == "settings" {
                if let destin = segue.destination as? settingsViewController
                {
                    destin.color = (self.settingsDictionary["theme"] as! UIColor)
                    destin.diff = (self.settingsDictionary["difficulty"] as! String)
                    destin.music = (self.settingsDictionary["music"] as! Bool)
                }
            } else if identifier == "play" {
                // need to pass the current high score and theme
                if let destin = segue.destination as? GameViewController {
                    destin.theme = (settingsDictionary["theme"] as! UIColor)
                    for x in scoresArray {
                        if x.position == 1 {
                            destin.highScore = Int(x.score)
                        }
                    }
                    destin.setting = (settingsDictionary["difficulty"] as! String)
                    destin.music = (settingsDictionary["music"] as! Bool)
                }
            }
        }
    }
}
