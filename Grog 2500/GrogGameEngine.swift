//
//  GrogGameEngine.swift
//  Grog 2500
//
//  Created by John Pavley on 4/5/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

class GregGameEngine {
    var score: Int
    var health: Double
    var secondsRemaining: Int
    var storyText: String
    var player: GrogGamePlayer
    
    init() {
        score = 0
        health = 0
        secondsRemaining = 0
        storyText = ""
        player = GrogGamePlayer()
    }
    
    func update() {
        // engine update
        player.update()
    }
}
