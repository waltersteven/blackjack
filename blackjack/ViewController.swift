//
//  ViewController.swift
//  blackjack
//
//  Created by ulima on 8/05/18.
//  Copyright © 2018 ulima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnTapDelegate {
    
    var activePlayer: String = "player"
    
    var objCard: Card!
    
    @IBOutlet var tableCards: [CardView]!
    @IBOutlet var playerCards: [CardView]!
    @IBOutlet weak var warning: UILabel!
    
    var cardsManager = CardsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var index = 1
        var faceUp = false
        for card in tableCards {
            if index <= 2 {
                faceUp = true
            }else {
                faceUp = false
            }
            
            objCard = Card(palo:String(Int(arc4random_uniform(4) + 1)), number: Int(arc4random_uniform(13) + 1),back: "mesa", turn: 1, faceUp: faceUp)
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
        
        index = 1
        faceUp = false
        for card in playerCards {
            if index <= 2 {
                faceUp = true
            }else {
                faceUp = false
            }
            objCard = Card(palo:String(Int(arc4random_uniform(4) + 1)), number: Int(arc4random_uniform(13) + 1), back: "jugador", turn: 2, faceUp: faceUp)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTapDelegate(validTap: Bool, score: Int, turn: Int) {
        
        if validTap {
            warning.isHidden = true
            cardsManager.calculateScore(score: score, turn: turn)
            let actualTurn = cardsManager.changeTurn()
            
            for card in tableCards {
                card.actualTurn = actualTurn
            }
            for card in playerCards {
                card.actualTurn = actualTurn
            }
        } else {
            warning.text = "No es tu turno"
            warning.isHidden = false
        }
        

    }
    
}

