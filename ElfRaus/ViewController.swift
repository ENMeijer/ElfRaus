//
//  ViewController.swift
//  ElferRaus
//
//  Created by F.T. Boie on 18/02/2019.
//  Copyright © 2019 F.T. Boie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //var game:elfRaus
    @IBOutlet var playingField: [UILabel]!
    
    @IBOutlet weak var playerCard1: UIButton!
    @IBOutlet weak var playerCard2: UIButton!
    @IBOutlet weak var playerCard3: UIButton!
    @IBOutlet weak var playerCard4: UIButton!
    
    //for testing, should be linked to hand in the game
    var hand = ["3 red", "2 blue", "10 yellow", "2 red"]
    
    
    @IBAction func drawButton(_ sender: UIButton) {
        //draw action
        playerCard1.setTitle("test", for: .normal)
    }
    @IBAction func nextButton(_ sender: UIButton) {
        //next card
        showHand()
    }
    
    func showHand(){
        playerCard1.setTitle(hand[0], for: .normal)
        playerCard2.setTitle(hand[1], for: .normal)
        playerCard3.setTitle(hand[2], for: .normal)
        playerCard4.setTitle(hand[3], for: .normal)

    }
    
    
}


