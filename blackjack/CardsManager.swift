//
//  cardsManager.swift
//  blackjack
//
//  Created by ulima on 8/05/18.
//  Copyright © 2018 ulima. All rights reserved.
//

import Foundation
import Darwin

class Card {
    var back: String
    var palo: String
    var number : Int
    var turn: Int
    var actualTurn: Int
    var faceUp: Bool
    
    init(palo: String, number: Int, back: String, turn: Int, faceUp: Bool) {
        self.palo = palo
        self.number = number
        self.back = back
        self.turn = turn
        self.actualTurn = 2
        self.faceUp = faceUp
    }

}

struct CardsManager {
    var playerScore: Int = 0
    var tableScore: Int = 0
    
    var actualTurn: Int = 2
    
    mutating func calculateScore(score: Int, turn: Int) {
        if turn == 2 {
            playerScore += score
        } else {
            tableScore += score
        }
        
        print("score")
        print(tableScore)
        print(playerScore)
    }
    
    mutating func checkWinner() -> String {
//        if playerScore <= 21 {
//            if playerScore > tableScore {
//                return "jugador"
//            } else{
//                 return "mesa"
//            }
//        }else if tableScore <= 21 {
//            if tableScore > playerScore {
//                return "mesa"
//            }else {
//                 return "jugador"
//            }
//        }else {
//            return "empate"
//        }
        
        if tableScore <= 21 && tableScore > playerScore {
                return "mesa"
        } else if tableScore > 21 {
            return "player"
        }
        
        if playerScore <= 21 && playerScore > tableScore {
            return "player"
        } else if playerScore > 21 {
            return "mesa"
        }else{
            return "empate"
        }

        
    }
    
    mutating func changeTurn() -> Int {
        if actualTurn == 2 {
            actualTurn = 1
            return actualTurn
        } else {
            actualTurn = 2
            return actualTurn
        }
    }
}

