//
//  MainMenuViewController.swift
//  ElfRaus
//
//  Created by F.T. Boie on 3/26/19.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewControllerAndVariablesPassedAround {
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        if(!self.questionsShown){
            let m = "Cards can be played in sequence from 11 up- and downwards. \n If you cannot play, you need to draw up to 3 Cards.\n Goal: Empty your hand first."
            let alertController = UIAlertController(title: "Short Rules", message: m, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Start Game", style: .default) { (action:UIAlertAction) in CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "showNewGameView", sender: nil)
            })
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true)
            self.questionsShown = true
        } else {
            self.performSegue(withIdentifier: "showNewGameView", sender: nil)
        }
    }
    
    @IBAction func continueGame (_ sender: UIButton) {
    performSegue(withIdentifier: "showContinueGameView", sender: nil)
    }
    
    @IBAction func showDifficulty(_ sender: UIButton) {
        performSegue(withIdentifier: "showDifficultyView", sender: nil)
    }
    
    @IBAction func showHelp(_ sender: UIButton) {
        performSegue(withIdentifier: "showHelpView", sender: nil)
    }
    
    @IBAction func showScores(_ sender: UIButton) {
        performSegue(withIdentifier: "showScoreView", sender: nil)
    }
    
    func initializeNewGame(){
        self.game = ElfRaus()
        self.game.changeModelDifficulty(Model: self.difficulty)
        self.hand = CardsPlayer()
        self.gameRunning = true
        self.score = []
        self.currentRound = 1
    }
    
    
    //viewControllerA is the menu and viewControllerB is where the segue goes to
    //organizes all segregations forward
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //specifies with seque should be used
        switch segue.identifier {
        case "showNewGameView":
            let viewControllerB = segue.destination as! ViewController
            initializeNewGame()
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        case "showContinueGameView":
            let viewControllerB = segue.destination as! ViewController
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        case "showDifficultyView":
            let viewControllerB = segue.destination as! DifficultyViewController
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        case "showHelpView":
            let viewControllerB = segue.destination as! UIViewControllerAndVariablesPassedAround
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        case "showScoreView":
            let viewControllerB = segue.destination as! ScoreViewController
            thingsToKeepTrackOf(from: self, to: viewControllerB)

        default:
            print("could not find the segue")
        }
    }
    
    // organizes all segregations backwards
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let viewControllerB = sender.source as? UIViewControllerAndVariablesPassedAround {
            // what should be done
            thingsToKeepTrackOf(from: viewControllerB, to: self)

            if (self.gameRunning){
                continueButton.isEnabled = true
                continueButton.alpha = 1
            } else {
                continueButton.isEnabled = false
                continueButton.alpha = 0.5
            }
        }
    }
}


