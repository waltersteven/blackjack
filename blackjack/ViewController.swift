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
    var activePlayer: String = "player"
    
    var objCard: Card!
    
    @IBOutlet var tableCards: [CardView]!
    @IBOutlet var playerCards: [CardView]!
    @IBOutlet weak var warning: UILabel!
    
    @IBAction func reload(_ sender: UIButton) {
        warning.isHidden = true
        cardsManager.tableScore = 0
        cardsManager.tableScore = 0
        createCard(deck: tableCards, back: "mesa", turn: 1)
        createCard(deck: playerCards, back: "jugador", turn: 2)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createCard(deck: tableCards, back: "mesa", turn: 1)
        createCard(deck: playerCards, back: "jugador", turn: 2)
    }
    
    @IBAction func stayButton(_ sender: UIButton) {
        calculateWinner()
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
                warning.isHidden = false
                
            } else if cardsManager.playerScore > 21 {
                warning.text = "Ganó la mesa"
                warning.isHidden = false
            }
            
        } else {
            warning.text = "No puedes tocar una baraja que no sea tuya"
            warning.isHidden = false
        }
        
        //checking if playerCards has it´s all elements revealed
        let fullTaps = playerCards.contains { $0.faceUp == false }
        print(fullTaps)
        if fullTaps == false {
            calculateWinner()
        }
    }
    
    func createCard(deck: [CardView], back: String, turn: Int) {
        var index = 1
        var faceUp = false
        
        for card in deck {
            if index <= 2 {
                faceUp = true
            }else {
                faceUp = false
            }
            
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
        for card in tableCards {
            if card.faceUp == false {
                card.faceUp = true
                cardsManager.calculateScore(score: card.number!, turn: card.turn!)
                
            }
        }
        if cardsManager.tableScore == 21 {
            warning.text = "Ganó la mesa"
            warning.isHidden = false
            
        } else if cardsManager.tableScore > 21 {
            warning.text = "Ganó el jugador"
            warning.isHidden = false
        } else {
            if cardsManager.tableScore > cardsManager.playerScore {
                warning.text = "Ganó la mesa"
                warning.isHidden = false
            }else {
                warning.text = "Ganó el jugador"
                warning.isHidden = false
            }
        }
    }
    
}
