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
        complexModel.loadModel(fileName: "elfRausModelComplex")
        for card in modelCards.cards{
            addCardToDM(card: card, model: model)
        }
        for card in modelCards.cards{
            addCardToDM(card: card, model: complexModel)
        }
        
        
    }
    
    public func turnComplexModel(cards: CardsModel) -> [String] {
        //Adding all the cards to the Declarative Memory
        self.modelCards = cards
        addAllcardsOfhandToDM(cards: cards, model: complexModel)
        setLegalOptions(cards: cards, model: complexModel)

        //Run the model until it waits for action of legal cards
        let legalOptions = cards.getLegalOptions()
        complexModel.run()
        
        var colour =  model.lastAction(slot: "colour")
        var direction = model.lastAction(slot: "direction")
        var number = 11
        var weightsPerLegalOption = [String:Int]()
        
        //Run the model through every legal option: 'the model looks at every card that is possible to play'
        for legalCard in 0...legalOptions!.endIndex-1 {
            colour = legalOptions![legalCard].colorString
            direction = legalOptions![legalCard].direction
            number = legalOptions![legalCard].number
            weightsPerLegalOption.updateValue(0, forKey: "\(colour!)-\(direction!)")
            complexModel.modifyLastAction(slot: "colour", value: "\(colour!)")
            complexModel.modifyLastAction(slot: "direction", value: "\(direction!)")
            if direction == "high" {
                complexModel.modifyLastAction(slot: "number", value: "\(number+1)")}
                else{complexModel.modifyLastAction(slot: "number", value: "\(number-1)") }
            
            //The model looks which cards are also in that direction and colour
            while number <= 20 && number >= 1 {
                print (number)
                if complexModel.lastAction(slot: "isa") == "card-present"{
                    let numberCard = (complexModel.lastAction(slot: "number")! as NSString).integerValue
                    print("numberCard:",numberCard)
                    weightsPerLegalOption.updateValue(numberCard, forKey: "\(colour!)-\(direction!)")
                }
                if direction == "high"{
                    number += 1
                }else{
                    number -= 1
                }
                complexModel.modifyLastAction(slot: "number", value: "\(number)")
                complexModel.run()
            }
            
            //Let the model run and retrieve opponents cards
            complexModel.modifyLastAction(slot: "next", value: "no")
            complexModel.run()
            if complexModel.lastAction(slot: "isa") == "player-card-played" {
                weightsPerLegalOption["\(colour!)-\(direction!)"]! -= legalOptions![legalCard].number
            }
            complexModel.run()
            if legalCard != (legalOptions?.endIndex)!-1{
            complexModel.run()
            }
        }
        //Calculate the max weight for the model's choice
        var maxWeight = -99
        var maxKey = ""
        for index in weightsPerLegalOption{
            if maxWeight < index.value {
                maxWeight = index.value
                maxKey = index.key
            }
        }
        print("weights: ", weightsPerLegalOption)
        let choosenColDir = maxKey.components(separatedBy: "-")
        return choosenColDir
    }
    
    
    public func turn(cards:CardsModel) -> [String]{
        //Adding all the cards to the DM
        self.modelCards = cards
        addAllcardsOfhandToDM(cards: cards, model: model)
        setLegalOptions(cards: cards, model: model)
        
        //Let the model run
        model.run()
        var modelCardColor = model.lastAction(slot: "colour")
        // Choose most common color of legal set.
        let mostCommonColor = modelCards.getMaxLegalOptionsColor()
        if mostCommonColor != "false" {
            model.modifyLastAction(slot: "colour", value: mostCommonColor)
        }
        //Let the model retrieve which direction it has to go.
        model.run()
        modelCardColor = mostCommonColor
        let modelCardDirection = model.lastAction(slot: "direction")
        let modelCardNumber = model.lastAction(slot: "number")
        var modelCardNumberInt : Int = 0
        if modelCardNumber != nil{
            modelCardNumberInt = (modelCardNumber! as NSString).integerValue
        }else{
            modelCardNumberInt = 99 // means error
        }
        print("model decision: ", modelCardDirection!, modelCardColor!, modelCardNumberInt)
        
        //Remove choosen card from DM
        let choosenChunk = getChunk(nameChunk: "card\(modelCardColor!)\(modelCardNumberInt)", model: model)
        removeChunkFromDM(model: model, chunk: choosenChunk)
        //print(model.buffers)
        return [mostCommonColor,modelCardDirection!]
    }
    
    func addCardToDM (card: Card, model: Model){
        let newChunk = Chunk(s: "card\(card.colorString)\(card.number)", m: model)
        if card.location == "Model" {
            newChunk.setSlot(slot: "isa", value: "card")
        }else{
            newChunk.setSlot(slot: "isa", value: "player-card")
        }
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



