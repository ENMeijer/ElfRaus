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
        //Set Legal options of hand in the chunks in DM to possible: "yes"
        setLegalOptions(cards: cards, model: model)

        addAllcardsOfhandToDM(cards: cards, model: model)
        //Let the model run
        print("dm of model: ", model.dm.chunks)
        model.run()
        var modelCardColor = model.lastAction(slot: "colour") // The model action
        // Choose most common color of legal set.
        let mostCommonColor = modelCards.getMaxLegalOptionsColor()
        if mostCommonColor != "false" {
            model.modifyLastAction(slot: "colour", value: mostCommonColor)
        }
        // Let model run again
        model.run()
        let modelCardDirection = model.lastAction(slot: "direction")
        let modelCardNumber = model.lastAction(slot: "number")
        print("model decision: ", modelCardDirection!, modelCardColor!)
        print("dm of model: ", model.dm.chunks)
        //print(model.buffers)
        //let playerAction = sender.currentTitle! // The player action
        print("waiting? ", model.waitingForAction)
        
        //Remove choosen card from DM
        let choosenChunk = getChunk(nameChunk: "card\(modelCardColor)\(modelCardNumber)", model: model)
        removeChunkFromDM(model: model, chunk: choosenChunk)
        return [mostCommonColor,modelCardDirection!]
    }
    
    func addCardToDM (card: Card, model: Model){
        let newChunk = Chunk(s: "card\(card.colorString)\(card.number)", m: model)
        newChunk.setSlot(slot: "colour", value: card.colorString)
        newChunk.setSlot(slot: "direction", value: card.direction)
        newChunk.setSlot(slot: "possible", value: "no")
        model.dm.addToDM(newChunk)

    }
    
    func getChunk (nameChunk: String, model: Model) -> Chunk{
        let chunk = model.dm.chunks[nameChunk]
        return chunk!
    }
    
    func getCardChunk(card: Card, model: Model) -> Chunk{
        let nameChunk = "card\(card.colorString)\(card.number)"
        let chunk = model.dm.chunks[nameChunk]
        return chunk!
    }
    
    func setLegalOptions(cards: CardsModel, model: Model ) {
        let legalOptions = cards.getLegalOptions()
        for legalCard in 0...legalOptions!.endIndex {
            let cardChunk = getCardChunk(card: legalOptions![legalCard], model: model)
            cardChunk.setSlot(slot: "possible", value: "yes")
        }
    }
    
    func removeChunkFromDM(model: Model, chunk: Chunk){
        model.dm.chunks.removeValue(forKey: chunk.name)
    }
    
    func addAllcardsOfhandToDM(cards: CardsModel, model: Model){
        for card in cards.cards{
            addCardToDM(card: card, model: model)
        }
    }
    
}



