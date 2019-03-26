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
    let complexModel = Model()

    init() {
        model.loadModel(fileName: "elfRausModel2")
        //print("model loaded")
        for card in modelCards.cards{
            addCardToDM(card: card, model: model)
        }
        
    }
    
    
    
    public func turn(cards:CardsModel) -> [String]{
        self.modelCards = cards
        //print(model.buffers)
        //Set Legal options of hand in the chunks in DM to possible: "yes"
        addAllcardsOfhandToDM(cards: cards, model: model)
        setLegalOptions(cards: cards, model: model)
        
        //Let the model run
        //print("dm of model: ", model.dm.chunks)
        model.run()
        var modelCardColor = model.lastAction(slot: "colour") // The model action
        
        // Choose most common color of legal set.
        let mostCommonColor = modelCards.getMaxLegalOptionsColor()
        if mostCommonColor != "false" {
            model.modifyLastAction(slot: "colour", value: mostCommonColor)
        }
        // Let model run again
        model.run()
        modelCardColor = mostCommonColor
        let modelCardDirection = model.lastAction(slot: "direction")
        let modelCardNumber = model.lastAction(slot: "number")
        //print(model.lastAction(slot: "number"))
        //print(modelCardNumber, modelCardDirection)
        var modelCardNumberInt : Int = 0
        if modelCardNumber != nil{
            modelCardNumberInt = (modelCardNumber! as NSString).integerValue
            //print("Card Number ",modelCardNumberInt)
        }else{
            modelCardNumberInt = 21
        }
        print("model decision: ", modelCardDirection!, modelCardColor!, modelCardNumberInt)

        //let playerAction = sender.currentTitle! // The player action
        //print("waiting? ", model.waitingForAction)
        
        //Remove choosen card from DM
        let choosenChunk = getChunk(nameChunk: "card\(modelCardColor!)\(modelCardNumberInt)", model: model)
        removeChunkFromDM(model: model, chunk: choosenChunk)
        //print(model.buffers)
        return [mostCommonColor,modelCardDirection!]
    }
    
    func addCardToDM (card: Card, model: Model){
        let newChunk = Chunk(s: "card\(card.colorString)\(card.number)", m: model)
        newChunk.setSlot(slot: "isa", value: "card")
        newChunk.setSlot(slot: "colour", value: card.colorString)
        newChunk.setSlot(slot: "direction", value: card.direction)
        newChunk.setSlot(slot: "possible", value: "no")
        newChunk.setSlot(slot: "number", value: String(card.number))
        model.dm.addToDM(newChunk)
    }
    
    func getChunk (nameChunk: String, model: Model) -> Chunk{
        let index = model.dm.chunks.index(forKey: nameChunk)
        let chunk = model.dm.chunks[index!].value
        return chunk
    }
    
    func getCardChunk(card: Card, model: Model) -> Chunk{
        let nameChunk = "card\(card.colorString)\(card.number)"
        //print(model.dm.chunks)
        let index = model.dm.chunks.index(forKey: nameChunk)
        let chunk = model.dm.chunks[index!].value
        return chunk
    }
    
    func setLegalOptions(cards: CardsModel, model: Model ) {
        let legalOptions = cards.getLegalOptions()
        for legalCard in 0...legalOptions!.endIndex-1 {
            let cardChunk = getCardChunk(card: legalOptions![legalCard], model: model)
            cardChunk.setSlot(slot: "possible", value: "yes")
        }
    }
    
    func removeChunkFromDM(model: Model, chunk: Chunk){
        model.dm.chunks.removeValue(forKey: chunk.name)
    }
    
    func removeCardFromDM(model: Model, card: Card) {
        let nameChunk = "card\(card.colorString)\(card.number)"
        model.dm.chunks.removeValue(forKey: nameChunk)
    }
    
    func addAllcardsOfhandToDM(cards: CardsModel, model: Model){
        for card in cards.cards{
            addCardToDM(card: card, model: model)
        }
    }
    
}



