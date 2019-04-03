//
//  CardsPlayer.swift
//  ElfRaus
//
//  Created by A. Bliek on 06/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit


class CardsPlayer : CardsHand{
    override var cards : [Card]{ didSet{ updateHandView()  }} // all cards
    var selectedCards = [Card]()
    var view = [Card]()  // all visible cards
    
    let cardsInPlayersHand = 10
    var playerCardsPivotView = 0
    var playerCardsColorView:UIColor? = nil //nil means no color; otherwise use one of the colors
    
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
    

    
    func playerHandGoLeft(){
        if playerCardsPivotView > 0{
            playerCardsPivotView -= 1
        }
        updateView()
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
        if(cards.endIndex > 2){
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
    
    override func drawCard(_ card:Card, allLegalOptions:[Int:Card]){
        cards.append(card)
        orderCards()
        for color in 0...3{
            if colors[color] == card.color{
                cardsPerColor[color] += 1
            }
        }
        let index = card.identifier
        if (allLegalOptions.index(forKey: index) != nil) {
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
    
    

    
}
