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
    var deck = Array(0...79)
    var cardsPlayer = [Card]()
    var cardsModel = [Card]()
    let totalCards = 80
    var cardsInDeck = 80
    var cardsPlayedGreen = [Int]()
    var cardsPlayedRed = [Int]()
    var cardsPlayedBlue = [Int]()
    var cardsPlayedYellow = [Int]()
    var playedCards = PlayedCards()
    
    
    var legalOptions = [Int:Card]()
    
    func getCardsPlayer() -> [Card]{
        return cardsPlayer
    }
    
    func drawCard(_ player: String){
        var cardIndex : Int
        cardIndex = deck[0]
        deck.remove(at: 0)
        if(cardsInDeck > 0){
            if(player == "Player"){
                cards[cardIndex].location = "Player"
                cardsPlayer.append(cards[cardIndex])
            } else{
                cards[cardIndex].location = "Model"
                cardsModel.append(cards[cardIndex])
            }
            cardsInDeck -= 1
        }
        print(cardIndex)
    }
    
    //probably not needed anymore --> class
    //add card to array of the color
    func addPlayedCardToColorArray(in color: UIColor, at index : Int){
        if(color == UIColor.green){
            cardsPlayedGreen.append(index)
        }else if(color == UIColor.blue){
            cardsPlayedBlue.append(index)
        }else if(color == UIColor.red){
            cardsPlayedRed.append(index)
        }else if(color == UIColor.yellow){
            cardsPlayedYellow.append(index)
        }
    }
    
    func chooseCard(at index : Int){
        print("chooseCard")
        let indexCardDeck = index //cardsPlayer[index].identifier
        //let chosenCard = cards[indexCardDeck]
        if (legalOptions.index(forKey: indexCardDeck) != nil) {
            print("play card")
            cards[index].location = "Played"
            if(cards[index].number > 11), (cards[index].number < 20){
                legalOptions.updateValue(cards[index+1], forKey: index+1)
            }else if(cards[index].number > 1), (cards[index].number > 11){
                legalOptions.updateValue(cards[index-1], forKey: index-1)
            }
            playedCards.newPlayedCard(color: cards[index].color, number: cards[index].number)
            playedCards.printPlayedCards()
            for indexCardPlayer in 0...cardsPlayer.endIndex-1{
                if(cardsPlayer[indexCardPlayer].identifier == index){
                    cardsPlayer.remove(at: indexCardPlayer)
                    break
                    }
            }
            
        } else{
            print(indexCardDeck)
        }
        
    }
    
    init(){
        var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
        
        //create all cards
        for color in 0...3 {
            for number in 1...20 {
                cards.append(Card(color: colors[color],number: number,location: "Deck", identifier : color*20+number ))
            }
            legalOptions.updateValue(cards[color*20+11], forKey: color*20+11)
        }
        deck.shuffle()
        //distribute the cards before first turn
        //cards.shuffle()
        let numberOfDistributedCards = 5
        for card in 1...numberOfDistributedCards {
            let cardPlayer = deck[card]
            deck.remove(at: card)
            cards[cardPlayer].location = "Player"
            cardsPlayer.append(cards[cardPlayer])
            
            let cardModel = deck[card]
            deck.remove(at: card)
            cards[cardModel].location = "Model"
            cardsModel.append(cards[cardModel])
            cardsInDeck -= 2
            print(card)
        }
    }
    
}
