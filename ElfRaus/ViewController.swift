//
//  ViewController.swift
//  ElferRaus
//
//  Created by F.T. Boie on 18/02/2019.
//  Copyright © 2019 F.T. Boie. All rights reserved.
//

import UIKit

//class ViewController: UIViewController, GameAndHandVariables {
class ViewController: UIViewControllerAndVariablesPassedAround {
    //SET VARIABLES
    //var game = ElfRaus()
    //var hand = CardsPlayer()
    //included in UIViewControllerAndVariablesPassedAround, because these two need to be passed around
    
    var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    lazy var topCardOnDrawButton = self.game.cards[self.game.deck[0]]
    var cardsDrawnByModel = 3
    
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
    
    
    
    @IBOutlet weak var nextButton: UIButton! {didSet{ updateNextButton()}}//{didSet{ nextButton.isEnabled = true}} //needs to be true if the model started
    @IBOutlet weak var drawButton: cardView! {didSet{ updateDrawButton()}}
    
    @IBOutlet weak var newlyDrawnCard: cardView!
    

    @IBOutlet weak var opponentView: UILabel! {didSet { updateOpponentsCardCountView()}}
    
    
    
    //ACTION FUNCTIONS
    
    @IBAction func touchCard(_ sender: cardView) {
        //print("hand: ",hand.cards)
        if let cardNumber = cardButtons.index(of: sender) {
            // only send information to model if card is present
            if(cardButtons[cardNumber].alpha == 1){
                game.chooseCard(at: hand.view[cardNumber].identifier, "Player")
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
    
    func won(){
        if(game.cardsPlayerClass.won){
            let m = "You won! \nScore model:"+String(game.cardsModelClass.countScore())+"\nScore Player: "+String(game.cardsPlayerClass.countScore())
            let alert = UIAlertController(title: "Winning?", message: m, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yeah", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yeah", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            //the game is over
            self.updateScore(playerScore: game.cardsPlayerClass.countScore(), modelScore: game.cardsModelClass.countScore())
            self.updateRound()
        }else if(game.cardsModelClass.won){
            let m = "The model won! \nScore model:"+String(game.cardsModelClass.countScore())+"\nScore Player: "+String(game.cardsPlayerClass.countScore())
            let alertController = UIAlertController(title: "Winning?", message: m, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Continue", style: .default) { (action:UIAlertAction) in
                print("You continue");
            }
            
            let action2 = UIAlertAction(title: "Show Score", style: .default) { (action:UIAlertAction) in
                CATransaction.setCompletionBlock({
                    self.performSegue(withIdentifier: "showScoreView", sender: nil)
                })
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true)
            self.updateViewFromModel()
            //the game is over
            self.updateScore(playerScore: game.cardsPlayerClass.countScore(), modelScore: game.cardsModelClass.countScore())
            self.updateRound() //already sets up the playing field
            self.updateViewFromModel()
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        cardsDrawnByModel = 0
        let cardsBeforeModel = game.cardsInDeck
        //next card
        if(!game.cardsPlayerClass.won), (!game.cardsModelClass.won){
            if(game.currentTurn.allowedToNextTurn()){
                game.newTurn("Player")
                showHand()
                game.turnModel()
                game.newTurn("Model")
                cardsDrawnByModel = cardsBeforeModel-game.cardsInDeck
                if (cardsDrawnByModel > 0 && cardsDrawnByModel <= 3){
                    perform(#selector(moveDrawnCardAnimation), with: nil, afterDelay: 0.2)
                }
                updateViewFromModel()
//            }else if (game.currentTurn.allowedToNextTurn()){
//                game.newTurn("Player")
//                showHand()
//                game.turnModel()
//                game.newTurn("Model")
//                updateViewFromModel()
            }else if(game.cardsInDeck == 0),(game.cardsPlayerClass.legalOptions == nil){
                game.newTurn("Player")
                showHand()
                game.turnModel()
                game.newTurn("Model")
                updateViewFromModel()
            }
        }else{
            won()
        }
    }
    
    @IBAction func drawButton(_ sender: UIButton) {
        if game.currentTurn.allowedToDrawCard() , game.cardsInDeck > 0 {
            //draw action
            if game.cardsInDeck > 0 {
                self.topCardOnDrawButton = self.game.cards[self.game.deck[0]]
            }
            game.drawCard("Player")
            hand = game.getCardsPlayer()
            updateColorCountButtonView()
            
            //animation
            perform(#selector(flip), with: nil, afterDelay: 0)
            
            
        }
        showHand()
        updateNextDrawButton()
    }
    
    @IBAction func showScore(_ sender: UIButton) {
        performSegue(withIdentifier: "showScoreView", sender: nil)
    }
    
    //ANIMATIONS
    @objc func flip() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: drawButton, duration: 0.75, options: transitionOptions, animations: {
            self.drawButton.setHandCardView(card: self.topCardOnDrawButton)
        },completion: { _ in
            self.drawButton.setDrawButton(cardsLeft: self.game.cardsInDeck)
            self.updateNextDrawButton()
        })
    }
    
    
    @objc func moveDrawnCardAnimation() {
        self.newlyDrawnCard.setDrawButton(cardsLeft: self.game.cardsInDeck)
        self.newlyDrawnCard.setCardView(cardNumber: cardsDrawnByModel) //set to a too high number to get a question mark
        self.newlyDrawnCard.center = self.drawButton.center
        self.newlyDrawnCard.isHidden = false
        UIView.transition(with: newlyDrawnCard, duration: 1.0, options: [.curveLinear], animations: {
            self.newlyDrawnCard.center = self.opponentView.center
        },completion: { _ in
            self.newlyDrawnCard.isHidden = true
        })
    }
    
    //performSegue(withIdentifier: "showDifficultyView", sender: nil)

    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //specifies with seque should be used
        switch segue.identifier {
        case "showScoreView":
            let viewControllerB = segue.destination as! ScoreViewController
            thingsToKeepTrackOf(from: self, to: viewControllerB)
        default:
            print("could not find the segue")
        }
    }
    
    

    
    //FUNCTIONS
    
    
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
        updateNextButton()
        updateDrawButton()
    }
    
    func updateDrawButton(){
        drawButton.setDrawButton(cardsLeft: game.cardsInDeck)
        if(game.currentTurn.allowedToDrawCard()&&game.cardsInDeck > 0){
            drawButton.enableDrawButton(true)
        } else {
            drawButton.enableDrawButton(false)
        }
        if(game.cardsInDeck>60){ //make it visible at the start of the game, otherwise when model starts the button will not get visible //??? check again
            drawButton.enableDrawButton(true)
        }
    }
    
    func updateNextButton(){
        if game.currentTurn.allowedToNextTurn(){
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else if(game.deck.count > 0){
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
    }
    
    
    func updateViewFromModel(){
        if(!game.cardsPlayerClass.won), (!game.cardsModelClass.won){
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
            updateDrawButton() //??? doulbe check how to simplefy
        }else{
            won()
        }
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



