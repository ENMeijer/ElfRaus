//
//  ScoreViewController.swift
//  ElfRaus
//
//  Created by F.T. Boie on 3/27/19.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit


class ScoreViewController: UIViewControllerAndVariablesPassedAround {
    
    @IBOutlet weak var continueButton: UIButton! {didSet {updateContinueButon() }}
    @IBOutlet var table: [UILabel]! {didSet{setupTable()}}
    
    @IBAction func showContinueGame(_ sender: UIButton) {
        performSegue(withIdentifier: "showContinueGame", sender: nil)
    }
    
    func updateContinueButon(){
        if self.gameRunning{
            continueButton.isEnabled = true
            continueButton.alpha = 1
        } else {
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //specifies with seque should be used
        switch segue.identifier {
        case "showContinueGame":
            let viewControllerB = segue.destination as! ViewController
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        default:
            print("could not find the segue")
        }
    }
    
    func setupTable(){
        //first erase eyeryting
        for cell in table {
            cell.text = ""
        }
        
        //only set needed numbers
        var roundNumber = 1
        var scorePlayer = 0
        var scoreModel  = 0
        for round in 1...self.roundsToPlay + 1{
            //order roundNumber, Player, Model
            if self.score.count/2 >= roundNumber {
                table[(round-1)*3+0].text = String(roundNumber); roundNumber += 1

                table[(round-1)*3+1].text = String(self.score[(round-1)*2]); scorePlayer += self.score[(round-1)*2] //Player score
                
                table[(round-1)*3+2].text = String(self.score[(round-1)*2+1]); scoreModel += self.score[(round-1)*2+1] //Model score
            } else {
                //this is where the final score is shown
                table[(round-1)*3+0].text = "Total"
                
                table[(round-1)*3+1].text = String(scorePlayer) //Player score
                
                table[(round-1)*3+2].text = String(scoreModel) //Model score
                break
            }
        }
    }
}
