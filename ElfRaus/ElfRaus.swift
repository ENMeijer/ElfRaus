//
//  ElfRaus.swift
//  ElfRaus
//
//  Created by A. Bliek on 21/02/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit


class ElfRaus {
    var cards = [Card]()
    var deck = [Card]()
    var cardsPlayer = [Card]()
    var cardsModel = [Card]()
    let totalCards = 80
    struct legalOption{
        var color : UIColor
        var number : Int
    }
    var legalOptions = [legalOption]()
    
    func getCardsPlayer() -> [Card]{
        return cardsPlayer
    }
    
    init(){
        var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
        
        for color in 0...3 {
            for number in 1...20 {
                cards.append(Card(color: colors[color],number: number,location: "Deck", identifier : color*number ))
            }
            legalOptions.append(legalOption(color: colors[color], number: 11))
        }
        
        //distribute the cards before first turn
        cards.shuffle()
        let numberOfDistributedCards = 5
        for card in 0...numberOfDistributedCards {
            cards[card].location = "Player"
            cardsPlayer.append(cards[card])
            cards[card + numberOfDistributedCards].location = "Model"
            cardsPlayer.append(cards[card + numberOfDistributedCards])
        }
    }
    
}
