//
//  CardsModel.swift
//  ElfRaus
//
//  Created by A. Bliek on 01/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.

import Foundation
import UIKit


class CardsModel :CardsHand{


    
    
    public func ableToPlayAllCards(hand:[Card], possibleCards:[Card]) -> Bool{
        print("in ableToPlay: "+String(hand.count) + " " + String(possibleCards.count))
        if(hand.count > 0),(possibleCards.count > 0),(possibleCards.count < 8),(hand.count != possibleCards.count){
            for card in 0...hand.endIndex-1 {
                if(possibleCards[0].identifier-1 == hand[card].identifier){
                    var p = possibleCards
                    p.remove(at: 0)
                    p.append(hand[card])
                    var h = hand
                    h.remove(at: card)
                    return ableToPlayAllCards(hand: h, possibleCards: p)
                }else if(possibleCards[0].identifier+1 == hand[card].identifier){
                    var p = possibleCards
                    p.remove(at: 0)
                    p.append(hand[card])
                    var h = hand
                    h.remove(at: card)
                    return ableToPlayAllCards(hand: h, possibleCards: p)
                }
            }
        }else if(hand.count == possibleCards.count){
            return true
        }else if(hand.count == 0){
            return true
        }
        return false
    }
    
  
  
    
    public func getMaxLegalOptionsColor() -> String{
        var maxColor = -1
        var maxAmount = 0
        for color in 0...3{
            if(legalOptionsColors[color]>0){
                if(cardsPerColor[color] > maxAmount){
                    maxColor = color
                    maxAmount = cardsPerColor[color]
                }
            }
        }
        if(maxColor > -1){
            print("cards per color: ", cardsPerColor)
            print("color array : ", legalOptionsColors)
            print("color array: ", colorString[maxColor])
            print("max Color : ", maxColor)
            return colorString[maxColor]
        }else{
            return "false"
        }
    }
    
    


    
}
