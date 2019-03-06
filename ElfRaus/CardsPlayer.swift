//
//  CardsPlayer.swift
//  ElfRaus
//
//  Created by A. Bliek on 06/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit


class CardsPlayer{
    var cardsPerColor = [0,0,0,0] //yellow green red blue
    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    var cards = [Card]() // all cards
    var hand = [Card]()  // all visible cards
    
    // TODO: add function to show cards for colors
    // TODO: add the functions for show hand from viewcontroller
    
    func drawCard(_ card:Card){
        cards.append(card)
        for color in 0...3{
            if colors[color] == card.color{
                cardsPerColor[color] += 1
            }
        }
    }
    
    func playCard(_ card:Card){
        for color in 0...3{
            if colors[color] == card.color{
                cardsPerColor[color] -= 1
            }
        }
        for indexCard in 0...cards.endIndex{
            if cards[indexCard].identifier == card.identifier{
                cards.remove(at: indexCard)
                break
            }
        }
    }
    
    func getAmountPerColor(color:UIColor) -> Int{
        for colorIndex in 0...colors.endIndex-1{
            if colors[colorIndex] == color{
                return cardsPerColor[colorIndex]
            }
        }
        return 0 // if color not present
    }
    
}
