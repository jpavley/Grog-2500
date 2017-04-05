//
//  GrogGameEngine.swift
//  Grog 2500
//
//  Created by John Pavley on 4/5/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

class GrogGameEngine {
    var score: Int
    var moves: Int
    var status: String
    var storyText: String
    var player: GrogGamePlayer
    
    init() {
        score = 0
        moves = 0
        status = "ready"
        storyText = "You are in a dark room. There is a cat, a bed, a lamp, and a light switch here. Maybe touching one of these things will do something interesting?\n>"
        player = GrogGamePlayer()
    }
    
    func update() {
        // engine update
        player.update()
    }
}
