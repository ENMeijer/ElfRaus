//
//  CardsModel.swift
//  ElfRaus
//
//  Created by A. Bliek on 01/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//NOT WORKINGggggg

import Foundation
import UIKit


class CardsModel{
    private var cardsPerColor = [0,0,0,0] //yellow green red blue
    private var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    private let colorString = ["yellow", "green", "red", "blue"]
    
    var cards = [Card]()
    private var legalOptions : [Card]?
    private var legalOptionsColors = [0,0,0,0] //yellow green red blue
    var won = false
    
    public func getLegalOptions() -> [Card]?{
        return legalOptions
    }
    
    public func getLegalOptionsColors() -> [Int]{
        return legalOptionsColors
    }
    
    
    public func countScore() -> Int {
        var score = 0
        for card in cards{
            score = score + card.number
        }
        return score
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
            for color in 0...3{
                if colors[color] == card.color{
                    legalOptionsColors[color] += 1
                }
            }
        }
        print("draw: ", card.number)
        print("options model: ",legalOptions as Any)
    }
    
    
    private func checkLegalOptions(_ card:Card, allLegalOptions:[Int:Card]){
        let index = card.identifier
        if (allLegalOptions.index(forKey: index) != nil) {
            var add = true
            if(legalOptions != nil){
                for cardLegal in legalOptions!{
                    if(card.identifier == cardLegal.identifier){
                        add = false
                    }
                }
            }
            if(add){
                print("key: ",allLegalOptions.index(forKey: index) as Any)
                if legalOptions != nil{
                    legalOptions!.append(card)
                }else{
                    legalOptions = [card]
                    
                }
                for color in 0...3{
                    if colors[color] == card.color{
                        legalOptionsColors[color] += 1
                    }
                }
            }
        }
    }
    
    func playCard(_ card:Card, allLegalOptions:[Int:Card]){
        for index in 0...legalOptions!.endIndex-1{
            if(legalOptions![index].identifier == card.identifier){
                legalOptions!.remove(at: index)
                if(legalOptions!.endIndex == 0){
                    legalOptions = nil
                }
                break
            }
        }
        for color in 0...3{
            if colors[color] == card.color{
                cardsPerColor[color] -= 1
                legalOptionsColors[color] -= 1
            }
        }
        for indexCard in 0...cards.endIndex{
            if cards[indexCard].identifier == card.identifier{
                cards.remove(at: indexCard)
                break
            }
        }
        for card in cards{
            checkLegalOptions(card, allLegalOptions: allLegalOptions)
        }
        if(cards.endIndex==0){
            won = true
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
    
    public func newTurn(allLegalOptions:[Int:Card]){
        for card in cards{
            checkLegalOptions(card, allLegalOptions: allLegalOptions)
        }
        print("options model: ", legalOptions)
    }
    
}
