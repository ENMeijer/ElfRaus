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
    var legalOptions : [Card]?
    
    func drawCard(_ card:Card, allLegalOptions:[Int:Card]){
        cards.append(card)
        for color in 0...3{
            if colors[color] == card.color{
                cardsPerColor[color] += 1
            }
        }
        let index = card.identifier
        if (allLegalOptions.index(forKey: index) != nil) {
            print("key: ",allLegalOptions.index(forKey: index) as Any)
            if legalOptions != nil{
                legalOptions!.append(card)
            }else{
                legalOptions = [card]
            }
        }
        print("draw: ", card.number)
        print("options model: ",legalOptions as Any)
    }
    //oh wow
    
    func playCard(_ card:Card){
        for index in 0...legalOptions!.endIndex-1{
            if(legalOptions![index].identifier == card.identifier){
                legalOptions!.remove(at: index)
            }
        }
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
