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
    var storybook: GrogStorybook
    var player: GrogGamePlayer
    var prompt = "\n>"
    
    init(storybook: GrogStorybook) {
        score = 0
        moves = 0
        status = "ready"
        self.storybook = storybook
        player = GrogGamePlayer()
    }
    
    func update() {
        // engine update
        player.update()
    }
}
