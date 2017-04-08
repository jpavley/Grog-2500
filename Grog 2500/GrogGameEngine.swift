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
    
    var currentStoryID: Int
    var currentPageID: Int
    var previousStoryID: Int
    var previousPageID: Int
    
    init(storybook: GrogStorybook) {
        score = 0
        moves = 0
        status = "ready"
        self.storybook = storybook
        player = GrogGamePlayer()
        currentStoryID = storybook.storyID
        currentPageID = storybook.pages[0].pageID
        previousPageID = noPage
        previousStoryID = noStory
    }
    
    func update() {
        // engine update
        player.update()
    }
}
