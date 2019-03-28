//
//  UIViewControllerAndVariablesPassedAround.swift
//  ElfRaus
//
//  Created by F.T. Boie on 26/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit

class UIViewControllerAndVariablesPassedAround: UIViewController{
    
    public var game = ElfRaus()
    public var hand = CardsPlayer()
    public var difficulty = "simpleModel"
    public var gameRunning = false
    public var score = [Int]()
    public var roundsToPlay = 10
    public var currentRound = 1
    
    func updateScore(playerScore:Int,modelScore:Int){
        self.score += [playerScore,modelScore]
    }
    func updateRound(){
        if self.currentRound >= self.roundsToPlay {
            self.gameRunning = false
        }
        self.currentRound += 1
    }
    
    func thingsToKeepTrackOf(from:UIViewControllerAndVariablesPassedAround, to:UIViewControllerAndVariablesPassedAround){
        to.game = from.game
        to.hand = from.hand
        to.difficulty = from.difficulty
        to.gameRunning = from.gameRunning
        to.score = from.score
        to.roundsToPlay = from.roundsToPlay
    }
}
