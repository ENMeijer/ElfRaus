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
    var selectedCards = [Card]()
    var view = [Card]()  // all visible cards
    var legalOptions : [Card]?
    var won = false
    let cardsInPlayersHand = 10
    
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
        if index >= selectedCards.endIndex || index < selectedCards.startIndex{
            //print("card does not exist")
            return nil
        }
        return selectedCards[index]
    }
    func getLegalOptions() -> [Card]?{
        return legalOptions
    }
    
    func playerHandGoLeft(){
        if playerCardsPivotView > 0{
            playerCardsPivotView -= 1
        }
        updateView()
    }
    
    public func countScore() -> Int {
        var score = 0
        for card in cards{
            score = score + card.number
        }
        return score
    }
    
    func playerHandGoRight(){
        if playerCardsPivotView < selectedCards.count-cardsInPlayersHand {
            // - the amount of cards
            playerCardsPivotView += 1
        }
        updateView()
    }
    
    func orderCards(){
        print(cards[0].identifier)
        if(cards.endIndex > 1){
            cards.sort(by: { $0.identifier < $1.identifier  })
        }
    }
    
    func updateView(){
        
        view = []
        if (selectedCards.endIndex>cardsInPlayersHand),(selectedCards.endIndex >= (cardsInPlayersHand+playerCardsPivotView)){
            view = Array(selectedCards[(0+playerCardsPivotView) ..< (cardsInPlayersHand+playerCardsPivotView)])
        } else if(playerCardsPivotView>0){
            playerCardsPivotView = playerCardsPivotView-1
            updateView()
        }else{
            view = selectedCards
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
        orderCards()
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
        //print(legalOptions!.endIndex-1)
        if(legalOptions != nil){
        for index in 0...(legalOptions!.endIndex-1){
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
        if(cards.endIndex == 0){
            won = true
        }
        print(legalOptions)
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
    
    func showHandByColor(_ color:UIColor?){
        playerCardsColorView = color
        playerCardsPivotView = 0
    }
    
    
    func updateHandView(){
        
        //only shows cards with a given attribute
        if playerCardsColorView == nil {    //if no color is given, then return the full hand
            selectedCards = cards
            updateView()
        } else {
            selectedCards = []
            for card in cards{
                if card.color == playerCardsColorView!{
                    selectedCards.append(card)
                }
            }
            updateView()
        }
    }
    
    
    public func newTurn(allLegalOptions:[Int:Card]){
        orderCards()
        for card in cards{
            checkLegalOptions(card, allLegalOptions: allLegalOptions)
        }
        print("options player: ", legalOptions)
    }
    
}
