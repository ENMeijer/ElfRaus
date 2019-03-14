//
//  Turn.swift
//  ElfRaus
//
//  Created by A. Bliek on 14/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation

struct Turn {
    
    private var drawnCards = 0
    private var cardOptions : [Card]?
    private var playedCards = 0
    
    init(cardOptions : [Card]?){
        self.cardOptions = cardOptions
    }
    
    public func allowedToPlayCard() -> Bool{
        if(playedCards < 8),(cardOptions != nil){
            return true
        }
        return false
    }
    
    public func allowedToDrawCard() -> Bool{
        if(drawnCards < 3), (cardOptions == nil), (playedCards == 0){
            return true
        }
        return false
    }
    
    public func allowedToNextTurn() -> Bool {
        print(playedCards)
        if(drawnCards == 3){
            if(playedCards > 0){
                return true
            } else if(cardOptions == nil){
                return true
            }
        } else if(playedCards > 0){
            return true
        }
        return false
    }
    
    public mutating func drawCard(cardOptions : [Card]?){
        drawnCards = drawnCards+1
        self.cardOptions = cardOptions
    }
    
    public mutating func playCard(cardOptions : [Card]?){
        playedCards = playedCards+1
        self.cardOptions = cardOptions
        print(playedCards)
    }
    
    
    
    
    
}
