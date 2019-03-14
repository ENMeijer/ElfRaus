//
//  ActRModel.swift
//  ElfRaus
//
//  Created by A. Bliek on 06/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation

class ActRModel{
    
    private var modelCards = CardsModel()
    let model = Model()
    

    init() {
        model.loadModel(fileName: "elfRausModel2")
        print("model loaded")
        for card in modelCards.cards{
            addCardToDM(card: card, model: model)
        }
        
    }
    
    public func turn(cards:CardsModel) -> [String]{
        print("!!!!!!!!!!!!!Model ActR!!!!!!!!!!!!!!!")
        self.modelCards = cards
        // First options:
        for card in modelCards.cards{
            addCardToDM(card: card, model: model)
        }
        modelCards.getLegalOptionsColors()
        model.run()
        //let playerAction = sender.currentTitle! // The player action
        var modelAction = model.lastAction(slot: "colour") // The model action
        let mostCommonColor = modelCards.getMaxLegalOptionsColor()
        if mostCommonColor != "false" {
            
            model.modifyLastAction(slot: "colour", value: mostCommonColor)
        }
        model.run()
        //print(modelAction)
        let modelDecision = model.lastAction(slot: "direction")
        modelAction = mostCommonColor
        print("model decision: ", modelDecision, modelAction)
        //print("dm of model: ", model.dm.chunks)
        //print(model.buffers)
        print("waiting? ", model.waitingForAction)
        
        return [mostCommonColor,modelDecision!]
    }
    
    
    func addCardToDM (card: Card, model: Model){
        let newChunk = Chunk(s: "card", m: model)
        //newChunk.setSlot(slot: "isa", value: "card")
        newChunk.setSlot(slot: "colour", value: card.colorString)
        newChunk.setSlot(slot: "direction", value: card.direction)
        newChunk.setSlot(slot: "possible", value: "yes")
        model.dm.addToDMOrStrengthen(chunk: newChunk.copy())
        model.dm.addToDMOrStrengthen(chunk: newChunk.copy())
    }
    
    
}



