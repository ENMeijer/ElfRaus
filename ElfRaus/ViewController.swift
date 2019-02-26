//
//  ViewController.swift
//  ElferRaus
//
//  Created by F.T. Boie on 18/02/2019.
//  Copyright © 2019 F.T. Boie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = ElfRaus()
    
    @IBOutlet var playingField: [UILabel]!
    
    @IBOutlet weak var playerCard1: UIButton!
    @IBOutlet weak var playerCard2: UIButton!
    @IBOutlet weak var playerCard3: UIButton!
    @IBOutlet weak var playerCard4: UIButton!
    
    //for testing, should be linked to hand in the game
    var hand = [Card]()
    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    

    @IBAction func drawButton(_ sender: UIButton) {
        //draw action
        playerCard1.setTitle("test", for: .normal)
    }
    @IBAction func nextButton(_ sender: UIButton) {
        //next card
        showHand()
    }
    
    func showHand(){
        hand = game.getCardsPlayer()
        
        playerCard1.setTitle(String(hand[0].number), for: .normal)
        playerCard1.setTitleColor(hand[0].color, for: .normal)
        playerCard2.setTitle(String(hand[1].number), for: .normal)
        playerCard2.setTitleColor(hand[1].color, for: .normal)
        playerCard3.setTitle(String(hand[2].number), for: .normal)
        playerCard3.setTitleColor(hand[2].color, for: .normal)
        playerCard4.setTitle(String(hand[3].number), for: .normal)
        playerCard4.setTitleColor(hand[3].color, for: .normal)
        print("showHand")

    }
    
    
}


