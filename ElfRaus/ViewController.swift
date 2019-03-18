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
    @IBOutlet weak var drawButton: UIButton!
    

    @IBOutlet weak var opponentView: UILabel! {didSet { updateOpponentsCardCountView()}}
    
    //ACTION FUNCTIONS
    
    @IBAction func touchCard(_ sender: cardView) {
        if let cardNumber = cardButtons.index(of: sender) {
            // only send information to model if card is present
            if(cardButtons[cardNumber].alpha == 1){
                let shouldChooseCard = game.chooseCard(at: hand.cards[cardNumber+hand.playerCardsPivotView].identifier, "Player")
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
        if(game.currentTurn.allowedToNextTurn()){
            game.newTurn("Player")
            showHand()
            game.turnModel()
            game.newTurn("Model")
            enableNextButton(false)
            updateViewFromModel()
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
    
    func enableDrawButton(_ isActive:Bool){
        if isActive{
            drawButton.isEnabled = true
            drawButton.alpha = 1
        } else {
            drawButton.isEnabled = false
            drawButton.alpha = 0.5
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
            if(hand.playerCardsPivotView >= hand.view.count-5){
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
        hand = game.getCardsPlayer() // currently will crash if there is problem

        for indexButton in 0...cardButtons.endIndex-1{
            if hand.cards.count >= indexButton+hand.playerCardsPivotView {
                cardButtons[indexButton].setHandCardView(card: hand.getCardAtPositionView(at: indexButton + hand.playerCardsPivotView))
            }
        }
        //check if you can go right or left
        enableGoThroughPlayerHand()
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


//EXTENSIONS
// handles setting hand with too few cards
extension UIButton {
    func setPlayerCardView(handCards: [Card], cardIndex: Int){
        //only accepts this
        if (cardIndex < handCards.count && cardIndex>=0) {
            self.setTitle(String(handCards[cardIndex].number), for: .normal)
            self.setTitleColor(handCards[cardIndex].color, for: .normal)
            self.backgroundColor = UIColor.lightGray
            
        }else {
            //print("player has one card to few")
            self.setTitle("", for: .normal)
            self.setTitleColor(UIColor.black, for: .normal)
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
        }
    }
}



