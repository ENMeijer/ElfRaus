//
//  ActRModel.swift
//  ElfRaus
//
//  Created by A. Bliek on 06/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation

class ActRModel{
    
    private var cards = CardsModel()
    let model = Model()
    

    init() {
        model.loadModel(fileName: "elfRausModel2")
        model.run()
        print("model loaded")
    }
    
    public func turn(cards:CardsModel){
        self.cards = cards
        model.run()
        
        //let playerAction = sender.currentTitle! // The player action
        let modelAction = model.lastAction(slot: "choice") // The model action
        // Do something with these two (i.e., decide who won)
        // Communicate the player's action back to the model by setting a slot // in the action buffer
        //model.modifyLastAction("opponent", value: playerAction.lowercaseString) // And run the model again for the next trial
        print(modelAction ?? "0")
        model.run()
        
    }
    
    
}
