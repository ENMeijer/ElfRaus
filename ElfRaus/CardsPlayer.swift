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
    var view = [Card]()  // all visible cards
    
    var playerCardsPivotView = 0
    var playerCardsColorView:UIColor? = nil //nil means no color; otherwise use one of the colors
    
    // TODO: add function to show cards for colors
    // TODO: add the functions for show hand from viewcontroller
    
    func getView()-> [Card]{
        updateHandView()
        return view
    }
    
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
    
    func showHandByColor(_ color:UIColor?){
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
        print(view.count)
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
                    print("card appended with right color")
                }
            }
        }
    }
    
    //???need to set the initial amount of cards
    
    
}
