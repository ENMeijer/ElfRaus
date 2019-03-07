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
    @IBOutlet var playingField: [PlayingCardView]!{didSet{initPlayingField(arrayPlayingField: playingField)}}
    
    @IBOutlet weak var playerCard1: UIButton!
    @IBOutlet weak var playerCard2: UIButton!
    @IBOutlet weak var playerCard3: UIButton!
    @IBOutlet weak var playerCard4: UIButton!
    @IBOutlet weak var playerCard5: UIButton!
    
    @IBOutlet var cardButtons: [UIButton]! {didSet{updateViewFromModel()}}

    
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    

    @IBOutlet weak var opponentView: UILabel!
    
    //ACTION FUNCTIONS
    @IBAction func drawButton(_ sender: UIButton) {
        enableNextButton(true)
        //draw action
        //playerCard1.setTitle("test", for: .normal)
        game.drawCard("Player")
        showHand()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        enableNextButton(true)
        if let cardNumber = cardButtons.index(of: sender) {
            // only send information to model if card is present
            if(cardButtons[cardNumber].backgroundColor == UIColor.lightGray){
                _ = game.chooseCard(at: hand.cards[cardNumber+hand.playerCardsPivotView].identifier, "Player")
                updateViewFromModel()
            }
        } else {
            print("choosen card was not in cardButtons")
        }
        showHand()
    }
    
    @IBAction func PlayerHandGoLeft(_ sender: UIButton) {
        //show more cards to the left in the player hand
        hand.playerHandGoLeft()
    }
    @IBAction func PlayerHandGoRight(_ sender: UIButton) {
        //show more cards to the right in the player hand
        hand.playerHandGoRight()
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
        enableNextButton(false)
        //next card
        showHand()
        var played = 0
        var cardsModel = game.getCardsModel()
        cardsModel.shuffle()
        var card = 0
        while (card < 5),(card<cardsModel.endIndex){
            //if(card < cardsModel.endIndex){
                print(card, cardsModel.endIndex)
                let valid = game.chooseCard(at: cardsModel[card].identifier, "Model")
                if valid{
                    played += 1
                    card = 0
                } else{
                    card+=1
                }
            //}
        }

        game.drawCard("Model")
        updateViewFromModel()
        
    }
    
    //FUNCTIONS
    
    func enableNextButton(_ isActive:Bool){
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
    

    
    
    func showHand(){
        hand = game.getCardsPlayer() // currently will crash if there is problem
        for button in 0...cardButtons.endIndex-1{
            cardButtons[button].setPlayerCardView(handCards: hand.getView(), cardIndex: button+hand.playerCardsPivotView)
        }
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
        playingField[1].setCardView(cardNumber: game.playedCards.yellow_low ?? 0)
        playingField[2].setCardView(cardNumber: game.playedCards.yellow_11 ? 11:-11)
        playingField[3].setCardView(cardNumber: game.playedCards.yellow_high ?? 0)
        playingField[4].setCardView(cardNumber: game.playedCards.red_low ?? 0)
        playingField[5].setCardView(cardNumber: game.playedCards.red_11 ? 11:-11)
        playingField[6].setCardView(cardNumber: game.playedCards.red_high ?? 0)
        playingField[7].setCardView(cardNumber: game.playedCards.green_low ?? 0)
        playingField[8].setCardView(cardNumber: game.playedCards.green_11 ? 11:-11)
        playingField[9].setCardView(cardNumber: game.playedCards.green_high ?? 0)
        playingField[10].setCardView(cardNumber: game.playedCards.blue_low ?? 0)
        playingField[11].setCardView(cardNumber: game.playedCards.blue_11 ? 11:-11)
        playingField[12].setCardView(cardNumber: game.playedCards.blue_high ?? 0)
        
        
        for card in playingField{
            card.setNeedsDisplay()
            card.setNeedsLayout()
            //print("update")
        }
    }
    
    func updateOpponentsCardCountView(){
        //set opponents number of cards in the view
        //currently not working due to nill exeption
        //opponentView.text = "Opponent's cards: \((game.getCardsModel().count))"}
        //opponentView.setNeedsLayout()
        //opponentView.setNeedsDisplay()
    }
    
    func updateColorCountButtonView(){
        //update count shown on the color buttons
        //missing other buttons
    }
    
    func initPlayingField(arrayPlayingField:[PlayingCardView]){
        //initialized the playing field
        playingField[1].setCardViewColor(cardColor: UIColor.yellow);
        playingField[2].setCardViewColor(cardColor: UIColor.yellow);
        playingField[3].setCardViewColor(cardColor: UIColor.yellow);
        playingField[4].setCardViewColor(cardColor: UIColor.red);
        playingField[5].setCardViewColor(cardColor: UIColor.red);
        playingField[6].setCardViewColor(cardColor: UIColor.red);
        playingField[7].setCardViewColor(cardColor: UIColor.green);
        playingField[8].setCardViewColor(cardColor: UIColor.green);
        playingField[9].setCardViewColor(cardColor: UIColor.green);
        playingField[10].setCardViewColor(cardColor: UIColor.blue);
        playingField[11].setCardViewColor(cardColor: UIColor.blue);
        playingField[12].setCardViewColor(cardColor: UIColor.blue);
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


