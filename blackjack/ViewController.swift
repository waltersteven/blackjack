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
        
        stay.layer.cornerRadius = stay.bounds.width / 2
        stay.clipsToBounds = true
        
        reload.layer.cornerRadius = reload.bounds.width / 2
        reload.clipsToBounds = true
        
        createCard(deck: tableCards, back: "mesa", turn: 1)
        createCard(deck: playerCards, back: "jugador", turn: 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            // code with delay
            self.initialChecking()
        }
    }
    
    @IBAction func stayButton(_ sender: UIButton) {
        for card in tableCards {
            if card.faceUp == false {
                card.faceUp = true
                cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                
            }
        }
        calculateWinner()
        changeTurnInAllCards()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTapDelegate(validTap: Bool, score: Int, turn: Int) {
    
        if validTap {
            warning.isHidden = true
            cardsManager.calculateScore(score: score, turn: turn)
            
            if cardsManager.playerScore == 21 {
                warning.text = "Ganó el jugador"
                showLabel()
                changeTurnInAllCards()
                
                for card in tableCards {
                    if card.faceUp == false {
                        card.faceUp = true
                    }
                }
                
            } else if cardsManager.playerScore > 21 {
                warning.text = "Ganó la mesa"
                showLabel()
                changeTurnInAllCards()
                
                for card in tableCards {
                    if card.faceUp == false {
                        card.faceUp = true
                    }
                }
            }
            
        } else {
            warning.text = "No puedes tocar esta carta"
            showLabel()
        }
        
        //checking if playerCards has it´s all elements revealed
        let fullTaps = playerCards.contains { $0.faceUp == false }

        if fullTaps == false {
            for card in tableCards {
                if card.faceUp == false {
                    card.faceUp = true
                    cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                    
                }
            }
            calculateWinner()
            changeTurnInAllCards()
        }
    }
    
    func createCard(deck: [CardView], back: String, turn: Int) {
        var index = 1
        var faceUp = false
        
        for card in deck {
            
            faceUp = index <= 2 ? true : false
            
            objCard = Card(palo:String(Int(arc4random_uniform(4) + 1)), number: Int(arc4random_uniform(13) + 1),back: back, turn: turn, faceUp: faceUp)
            card.palo = objCard.palo
            card.number = objCard.number
            card.back = objCard.back
            card.turn = objCard.turn
            card.actualTurn = objCard.actualTurn
            card.faceUp = objCard.faceUp
            card.onTapDelegate = self
            
            if card.faceUp == true {
                cardsManager.calculateScore(score: card.number!, turn: card.turn!)
            }
            index = index + 1
        }
        
    }
    
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
    
    func changeTurnInAllCards() {
        let actualTurn = cardsManager.changeTurn()
        print("actual turn: " + String(actualTurn))
        for card in tableCards { card.actualTurn = actualTurn }
        for card in playerCards { card.actualTurn = actualTurn }
    }
    
    func showLabel() {
        warning.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        warning.isHidden = false
        showEffect(label: warning)
    }
    
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
    
}
