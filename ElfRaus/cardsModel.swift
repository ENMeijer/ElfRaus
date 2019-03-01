//
//  CardsModel.swift
//  ElfRaus
//
//  Created by A. Bliek on 01/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit


class CardsModel{
    var cardsPerColor = [0,0,0,0] //yellow green red blue
    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    
    var cards = [Card]()
    
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
