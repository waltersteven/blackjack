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
    var	faceUp: Bool
    var enable: Bool //
    
    init(palo: String, number: Int, back: String, turn: Int, faceUp: Bool, enable: Bool) { //
        self.palo = palo
        self.number = number
        self.back = back
        self.turn = turn
        self.actualTurn = 2
        self.faceUp = faceUp
        self.enable = enable //
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

