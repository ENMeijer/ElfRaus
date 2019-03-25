//
//  ViewController.swift
//  ElferRaus
//
//  Created by F.T. Boie on 18/02/2019.
//  Copyright © 2019 F.T. Boie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //SET VARIABLES
    var game = ElfRaus()
    var hand = CardsPlayer()

    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    
    //SET OUTLETS
    @IBOutlet var playingField: [cardView]! {didSet{initPlayingField()}}

    @IBOutlet weak var playerCard1: cardView!
    @IBOutlet weak var playerCard2: cardView!
    @IBOutlet weak var playerCard3: cardView!
    @IBOutlet weak var playerCard4: cardView!
    @IBOutlet weak var playerCard5: cardView!
    
    @IBOutlet weak var playerCard6: cardView!
    @IBOutlet weak var playerCard7: cardView!
    @IBOutlet weak var playerCard8: cardView!
    @IBOutlet weak var playerCard9: cardView!
    @IBOutlet weak var playerCard10: cardView!
    
    
    @IBOutlet var cardButtons: [cardView]! {didSet{showHand()}}
    
    
    

    @IBOutlet weak var goLeftButton: UIButton! {didSet{ enableGoThroughPlayerHand()}}
    @IBOutlet weak var goRightButton: UIButton! {didSet{ enableGoThroughPlayerHand()}}
    
    
    
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    
    @IBOutlet var colorButtons: [UIButton]! {didSet { updateColorCountButtonView()}}
    
    
    
    @IBOutlet weak var nextButton: UIButton! {didSet{ enableNextButton(false)}}
    @IBOutlet weak var drawButton: cardView! {didSet{ updateDrawButton()}}
    
    

    @IBOutlet weak var opponentView: UILabel! {didSet { updateOpponentsCardCountView()}}
    
    //ACTION FUNCTIONS
    
    @IBAction func touchCard(_ sender: cardView) {
        //print("hand: ",hand.cards)
        if let cardNumber = cardButtons.index(of: sender) {
            // only send information to model if card is present
            if(cardButtons[cardNumber].alpha == 1){
                let shouldChooseCard = game.chooseCard(at: hand.view[cardNumber].identifier, "Player")
                if shouldChooseCard{
                    if(game.currentTurn.allowedToNextTurn()){
                        enableNextButton(true)
                    }
                }
                updateViewFromModel()
            }
        }else {
            print("choosen card was not in cardButtons")
        }
        showHand()
    }
    
    @IBAction func PlayerHandGoLeft(_ sender: UIButton) {
        //show more cards to the left in the player hand
        hand.playerHandGoLeft()
        showHand()
    }
    @IBAction func PlayerHandGoRight(_ sender: UIButton) {
        //show more cards to the right in the player hand
        hand.playerHandGoRight()
        showHand()
    }
    
    @IBAction func YellowButton(_ sender: UIButton) {
        //only show yellow cards
        hand.showHandByColor(UIColor.yellow)
        showHand()
    }
    @IBAction func RedButton(_ sender: UIButton) {
        //only show red cards
        hand.showHandByColor(UIColor.red)
        showHand()
    }
    @IBAction func GreenButton(_ sender: UIButton) {
        //only show green cards
        hand.showHandByColor(UIColor.green)
        showHand()
    }
    @IBAction func BlueButton(_ sender: UIButton) {
        //only show blue cards
        hand.showHandByColor(UIColor.blue)
        showHand()
    }
    @IBAction func WhiteButton(_ sender: UIButton) {
        //show all colour cards
        hand.showHandByColor(nil)
        showHand()
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        //next card
        if(!game.cardsPlayerClass.won), (!game.cardsModelClass.won){
            if(game.currentTurn.allowedToNextTurn()){
                game.newTurn("Player")
                showHand()
                game.turnModel()
                game.newTurn("Model")
                enableNextButton(false)
                updateViewFromModel()
            } else if(game.cardsInDeck == 0){
                game.newTurn("Player")
                showHand()
                game.turnModel()
                game.newTurn("Model")
                enableNextButton(false)
                updateViewFromModel()
            }
        }else if(game.cardsPlayerClass.won){
            let alert = UIAlertController(title: "Winning?", message: "You won!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yeah", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yeah", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: "Winning?", message: "The model won!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Oww", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Oww", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func drawButton(_ sender: UIButton) {
        
        //draw action
        game.drawCard("Player")
        hand = game.getCardsPlayer()
        hand.showTheNewlyDrawnCard()
        updateColorCountButtonView()
        if(game.currentTurn.allowedToNextTurn()){
            enableNextButton(true)
        }
        showHand()
        updateNextDrawButton()
    }

    
    //FUNCTIONS
    
    func enableNextButton(_ isActive:Bool){
        print("enable")
        if isActive{
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
        
    }
    
    func enableGoThroughPlayerHand(){
        hand = game.getCardsPlayer()
        //check for going left
        if goLeftButton != nil {
            if(hand.playerCardsPivotView <= 0){
                goLeftButton.isEnabled = false
                goLeftButton.alpha = 0.5
            } else {
                goLeftButton.isEnabled = true
                goLeftButton.alpha = 1
            }
        }
        //check for going right
        if goRightButton != nil{
            if(hand.playerCardsPivotView >= hand.selectedCards.count-cardButtons.endIndex){
                goRightButton.isEnabled = false
                goRightButton.alpha = 0.5
            } else {
                goRightButton.isEnabled = true
                goRightButton.alpha = 1
            }
        }
        
    }
    
    
    func showHand(){
        //set start hand
        hand = game.getCardsPlayer()

        for indexButton in 0...cardButtons.endIndex-1{
            if hand.view.count >= indexButton{
                cardButtons[indexButton].setHandCardView(card: hand.getCardAtPositionView(at: indexButton + hand.playerCardsPivotView))
            } else {
                cardButtons[indexButton].setHandCardView(card: nil)
            }
        }
        //check if you can go right or left
        enableGoThroughPlayerHand()
    }
    
    func updateNextDrawButton(){
        drawButton.enableDrawButton(game.currentTurn.allowedToDrawCard())
        enableNextButton(game.currentTurn.allowedToNextTurn())
        if game.currentTurn.allowedToPlayCard(){
            drawButton.enableDrawButton(false)
            //enableNextButton(false)
        }else if(game.cardsInDeck == 0){
            enableNextButton(true)
        }
        updateDrawButton()
    }
    
    func updateDrawButton(){
        drawButton.setDrawButton(cardsLeft: game.cardsInDeck)
        drawButton.enableDrawButton(game.currentTurn.allowedToDrawCard())
    }
    
    
    
    func updateViewFromModel(){
        //update playing field view
        updatePlayingFieldView()
        //update oppoenents card count from model
        updateOpponentsCardCountView()
        //update Player Cards
        showHand()
        //update the number of cards a player has per color
        updateColorCountButtonView()
        //update draw and next button
        updateNextDrawButton()
        updateDrawButton()
    }
    
    func updatePlayingFieldView(){
        if playingField != nil{
            playingField[0].setCardView(cardNumber: game.playedCards.yellow_low ?? 0)
            playingField[1].setCardView(cardNumber: game.playedCards.yellow_11 ? 11:-11)
            playingField[2].setCardView(cardNumber: game.playedCards.yellow_high ?? 0)
            playingField[3].setCardView(cardNumber: game.playedCards.red_low ?? 0)
            playingField[4].setCardView(cardNumber: game.playedCards.red_11 ? 11:-11)
            playingField[5].setCardView(cardNumber: game.playedCards.red_high ?? 0)
            playingField[6].setCardView(cardNumber: game.playedCards.green_low ?? 0)
            playingField[7].setCardView(cardNumber: game.playedCards.green_11 ? 11:-11)
            playingField[8].setCardView(cardNumber: game.playedCards.green_high ?? 0)
            playingField[9].setCardView(cardNumber: game.playedCards.blue_low ?? 0)
            playingField[10].setCardView(cardNumber: game.playedCards.blue_11 ? 11:-11)
            playingField[11].setCardView(cardNumber: game.playedCards.blue_high ?? 0)

        
        
            for card in playingField{
                card.setNeedsDisplay()
                card.setNeedsLayout()
                //print("update")
            }
        } else {
            print("there is nothing in playing field")
        }
    }
    
    func updateOpponentsCardCountView(){
        if opponentView != nil{ // if the layer opponent already exists
            if game.getCardsModel().count >= 0{ // if the oppoenent has 0 or more cards in hand
                opponentView.text = "Opponent's cards: \(game.getCardsModel().count)"
                opponentView.setNeedsLayout()
                opponentView.setNeedsDisplay()
            }
        }
    }
    
    func updateColorCountButtonView(){
        //update count shown on the color buttons
        //update hand first
        hand = game.getCardsPlayer()
        var cardsPerColor = hand.cardsPerColor
        cardsPerColor.append(hand.cards.count) // calculate the total number of cards
        if colorButtons != nil { // IF Color buttons are initialized
            for index in 0...cardsPerColor.count-1{
                if cardsPerColor[index] >= 0 {
                    colorButtons[index].setTitle(String(cardsPerColor[index]), for: .normal)
                    colorButtons[index].setNeedsLayout()
                    colorButtons[index].setNeedsDisplay()
                }
                
            }
        }
    }
    
    func initPlayingField(){
        //initialized the playing field
        if playingField != nil {
            playingField[0].setCardViewColor(cardColor: UIColor.yellow);
            playingField[1].setCardViewColor(cardColor: UIColor.yellow);
            playingField[2].setCardViewColor(cardColor: UIColor.yellow);
            playingField[3].setCardViewColor(cardColor: UIColor.red);
            playingField[4].setCardViewColor(cardColor: UIColor.red);
            playingField[5].setCardViewColor(cardColor: UIColor.red);
            playingField[6].setCardViewColor(cardColor: UIColor.green);
            playingField[7].setCardViewColor(cardColor: UIColor.green);
            playingField[8].setCardViewColor(cardColor: UIColor.green);
            playingField[9].setCardViewColor(cardColor: UIColor.blue);
            playingField[10].setCardViewColor(cardColor: UIColor.blue);
            playingField[11].setCardViewColor(cardColor: UIColor.blue);
            updatePlayingFieldView()
        } else {
            print("playing field is nil")
        }
    }
    
}



