//
//  CardsManager.swift
//  blackjack
//
//  Created by ulima on 8/05/18.
//  Copyright © 2018 ulima. All rights reserved.
//

import Foundation
import Darwin

class Card {
    var palo: Int
    var number : Int
    
    init(palo: Int, number: Int) {
        self.palo = palo
        self.number = number
    }
}

struct CardsManager {
    var cardPackage: [Card] = []
    
    var randomPalo = Int(arc4random_uniform(4) + 1)
    var randomNumber = Int(arc4random_uniform(13) + 1)
    
    init() {
        self.cardPackage.append(Card(palo: randomPalo, number: randomNumber))
    }
}
