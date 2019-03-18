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
    var cards = [Card](){ didSet{ updateHandView()}} // all cards
    var view = [Card]()  // all visible cards
    var legalOptions : [Card]?
    
    var playerCardsPivotView = 0
    var playerCardsColorView:UIColor? = nil //nil means no color; otherwise use one of the colors
    
    // TODO: add function to show cards for colors
    // TODO: add the functions for show hand from viewcontroller
    
    func getView()-> [Card]{
        updateHandView()
        return view
    }
    
    func getCardAtPositionView(at index:Int)-> Card?{
        updateHandView()
        if index >= view.endIndex || index < view.startIndex{
            print("card does not exist")
            return nil
        }
        return view[index]
    }
    func getLegalOptions() -> [Card]?{
        return legalOptions
    }
    
    func playerHandGoLeft(){
        if playerCardsPivotView > 0{
            playerCardsPivotView -= 1
        }
    }
    
    func playerHandGoRight(){
        if playerCardsPivotView < view.count-5 {
            playerCardsPivotView += 1
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
        }
        print("draw: ", card.number)
        print("options player: ",legalOptions as Any)
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
        for card in cards{
            checkLegalOptions(card, allLegalOptions: allLegalOptions)
        }
        print(legalOptions)
    }
    
    func getAmountPerColor(color:UIColor) -> Int{
        for colorIndex in 0...colors.endIndex-1{
            if colors[colorIndex] == color{
                return cardsPerColor[colorIndex]
            }
        }
        return 0 // if color not present
    }
    
    func showHandByColor(_ color:UIColor?){
        //TODO: change only pivot if shown different color
        //??? should only change the pivot, after the hand is ordered; currently not working
//        switch color {
//        case colors[0]:
//            //show from yellow onward
//            playerCardsPivotView = 0
//        case colors[1]:
//            //show from green onward
//            playerCardsPivotView = cardsPerColor[0]
//        case colors[2]:
//            //show from green onward
//            playerCardsPivotView = cardsPerColor[0]+cardsPerColor[1]
//        case colors[3]:
//            //show from green onward
//            playerCardsPivotView = cardsPerColor[0]+cardsPerColor[1]+cardsPerColor[2]
//        default:
//            playerCardsPivotView = 0
//        }
        // ??? current setting while the hand is not ordered
        playerCardsColorView = color
        playerCardsPivotView = 0
    }
    
    func showTheNewlyDrawnCard(){
        // scroll until you see the new card
        // update the view
        if view.count <= 5{
            playerCardsPivotView = 0
        } else {
            playerCardsPivotView = view.count-5
        }
    }
    
    func updateHandView(){
        //only shows cards with a given attribute
        if playerCardsColorView == nil {    //if no color is given, then return the full hand
            view = cards
        } else {
            view = []
            for card in cards{
                if card.color == playerCardsColorView!{
                    view.append(card)
                }
            }
        }
    }
    
    
    public func newTurn(allLegalOptions:[Int:Card]){
        for card in cards{
            checkLegalOptions(card, allLegalOptions: allLegalOptions)
        }
        print("options player: ", legalOptions)
    }
    
}
