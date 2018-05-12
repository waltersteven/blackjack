//
//  ViewController.swift
//  blackjack
//
//  Created by ulima on 8/05/18.
//  Copyright © 2018 ulima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnTapDelegate {
    var cardsManager = CardsManager()
    var animator: UIViewPropertyAnimator!
    var activePlayer: String = "player"
    
    var objCard: Card!
    
    @IBOutlet var tableCards: [CardView]!
    @IBOutlet var playerCards: [CardView]!
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var stay: UIButton!
    @IBOutlet weak var reload: UIButton!
    
    @IBOutlet weak var tableScore: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    
    //an IBAction called whenever "reiniciar" button is called
    @IBAction func reloadButton(_ sender: UIButton) {
        warning.isHidden = true
        
        cardsManager.tableScore = 0
        cardsManager.playerScore = 0
        cardsManager.actualTurn = 2
        
        deckAnimation(deck: tableCards)
        deckAnimation(deck: playerCards)
        
        createCard(deck: tableCards, back: "mesa", turn: 1)
        createCard(deck: playerCards, back: "jugador", turn: 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            // code with delay
            self.initialChecking()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deckAnimation(deck: tableCards)
        deckAnimation(deck: playerCards)
        
        warning.layer.cornerRadius = 15
        warning.clipsToBounds = true
        
        tableScore.layer.cornerRadius = 8
        tableScore.clipsToBounds = true
        
        playerScore.layer.cornerRadius = 8
        playerScore.clipsToBounds = true
        
        stay.layer.cornerRadius = stay.bounds.width / 2
        stay.clipsToBounds = true
        
        reload.layer.cornerRadius = reload.bounds.width / 2
        reload.clipsToBounds = true
        
        createCard(deck: tableCards, back: "mesa", turn: 1)
        createCard(deck: playerCards, back: "jugador", turn: 2)
        
        //works as a settimeout
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            // code with delay
            self.initialChecking()
        }
    }
    
    //an IBAction called whenever "quedar" button is called
    @IBAction func stayButton(_ sender: UIButton) {
        for card in tableCards {
            if card.faceUp == false {
                card.faceUp = true
                let scoreValues = cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                showScoreonScreen(scores: scoreValues)
            }
        }
        calculateWinner()
        changeTurnInAllCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //an implemented function for a protocol (delegate) in order to communicate with the view
    func onTapDelegate(validTap: Bool, score: Int, turn: Int) {
    
        if validTap {
            warning.isHidden = true
            let scoreValues = cardsManager.calculateScore(score: score, turn: turn)
            showScoreonScreen(scores: scoreValues)
            
            if cardsManager.playerScore == 21 {
                warning.text = "Ganó el jugador"
                showLabel()
                changeTurnInAllCards()
            } else if cardsManager.playerScore > 21 {
                warning.text = "Ganó la mesa"
                showLabel()
                changeTurnInAllCards()
            }
            
        } else {
            warning.text = "No puedes tocar esta carta"
            showLabel()
        }
        
        //checking if playerCards has it´s all elements revealed
        let fullTaps = playerCards.contains { $0.faceUp == false }
        
        if cardsManager.playerScore < 21 {
            if fullTaps == false {
                for card in tableCards {
                    if card.faceUp == false {
                        card.faceUp = true
                        let scoreValues = cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                        showScoreonScreen(scores: scoreValues)
                    }
                }
                calculateWinner()
                changeTurnInAllCards()
            }
        
        }
        
    }
    
    //a function that creates each card of the game (set values to each view)
    func createCard(deck: [CardView], back: String, turn: Int) {
        var index = 1
        var faceUp = false
        
        var enable = true
        if deck == tableCards {
            enable = false
        }
        
        for card in deck {
            faceUp = index <= 2 ? true : false
            
            //creating each card with some variables with random values and assigning the delegate
            objCard = Card(palo:String(Int(arc4random_uniform(4) + 1)), number: Int(arc4random_uniform(13) + 1),back: back, turn: turn, faceUp: faceUp, enable: enable)
            card.palo = objCard.palo
            card.number = objCard.number
            card.back = objCard.back
            card.turn = objCard.turn
            card.actualTurn = objCard.actualTurn
            card.faceUp = objCard.faceUp
            card.enable = objCard.enable
            card.onTapDelegate = self
            
            if card.faceUp == true {
                let scoreValues = cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                showScoreonScreen(scores: scoreValues)
            }
            index = index + 1
        }
        
        
    }
    
    //a function that calculate the winner on distincts scenarios
    func calculateWinner() {

        if (cardsManager.playerScore == 21 && cardsManager.tableScore == 21) || (cardsManager.playerScore == cardsManager.tableScore) {
            warning.text = "Es un empate"
            showLabel()
        } else if cardsManager.playerScore == 21 {
            warning.text = "Ganó el jugador"
            showLabel()
        } else if cardsManager.tableScore == 21 {
            warning.text = "Ganó la mesa"
            showLabel()
        } else if cardsManager.playerScore > cardsManager.tableScore {
            if cardsManager.playerScore <= 21 {
                warning.text = "Ganó el jugador"
                showLabel()
            } else {
                warning.text = "Ganó la mesa"
                showLabel()
            }
        } else if cardsManager.playerScore < cardsManager.tableScore {
            if cardsManager.tableScore <= 21 {
                warning.text = "Ganó la mesa"
                showLabel()
            } else {
                warning.text = "Ganó el jugador"
                showLabel()
            }
            
        } else {
            warning.text = "Los dos volaron"
            showLabel()
        }
        
    }
    
    //a function that validate card values at the beginning of the game
    func initialChecking() {
        
        if cardsManager.playerScore == 21 && cardsManager.tableScore == 21 {
            warning.text = "Es un empate"
            showLabel()
            changeTurnInAllCards()
        } else if cardsManager.playerScore == 21 {
            warning.text = "Ganó el jugador"
            showLabel()
            changeTurnInAllCards()
        } else if cardsManager.tableScore == 21 {
            warning.text = "Ganó la mesa"
            showLabel()
            changeTurnInAllCards()
        } else if cardsManager.tableScore > 21 {
            warning.text = "Ganó el jugador"
            showLabel()
            changeTurnInAllCards()
        }else if cardsManager.playerScore > 21{
            warning.text = "Ganó la mesa"
            showLabel()
            changeTurnInAllCards()
        } else if cardsManager.tableScore > 21 && cardsManager.playerScore > 21 {
            warning.text = "Los dos volaron"
            showLabel()
            changeTurnInAllCards()
        }
        
    }
    
    //a function that change the turn of the game calling de card manager
    func changeTurnInAllCards() {
        let actualTurn = cardsManager.changeTurn()
        for card in tableCards { card.actualTurn = actualTurn }
        for card in playerCards { card.actualTurn = actualTurn }
    }
    
    //a small function in order to show a message label
    func showLabel() {
        warning.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        warning.isHidden = false
        showEffect(label: warning)
    }
    
    //function that executes an effect
    func showEffect(label: UILabel?, casilla boton: UIButton? = nil){
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 7.0,
                       options: .allowUserInteraction,
                       animations: {
                        if boton != nil {
                            boton!.transform = .identity
                        }
                        if label != nil {
                            label!.transform = .identity
                        }
        },
                       completion: nil)
    }
    
    //function that executes an animation on each deck
    func deckAnimation(deck: [CardView]) {

            for index in 0...deck.count-1 {
                deck[index].frame.origin.x -= self.view.frame.width * CGFloat(index+1) //movemos al objeto a la izquierda
                //instanciamos animator
                self.animator = UIViewPropertyAnimator(duration: 2, curve: .easeOut, animations:
                    { ()->Void in
                        deck[index].frame.origin.x += self.view.frame.width * CGFloat(index+1) //moviendo a posicion correcta
                })
                
                self.animator.startAnimation()
            }
    }
    
    //function that shows the score of each player on screen
    func showScoreonScreen(scores: [Int]) {
        tableScore.text = "Mesa: \(scores[0])"
        playerScore.text = "Jugador: \(scores[1])"
        
        tableScore.isHidden = false
        playerScore.isHidden = false
    }
    
}
