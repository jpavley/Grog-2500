//
//  GrogGamePlayer.swift
//  Grog 2500
//
//  Created by John Pavley on 4/5/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

struct GrogGamePlayer {
    var playerID: Int
    var health: Int
    var location: String
    
    init() {
        playerID = noPlayer
        health = 100
        location = "nowhere"
    }
    
    func update() {
        // TODO: update player properties
    }
}
