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
    var player: GrogGamePlayer
    
    var storybooks = [GrogStorybook]()
    var currentStoryID: Int
    var currentPageID: Int
    var previousPageID: Int
    var previousStoryText: String
    
    let prompt = "\n>"
    
    init(storybook: GrogStorybook) {
        score = 0
        moves = 0
        status = "ready"
        
        player = GrogGamePlayer()
        
        storybooks.append(storybook)
        currentStoryID = storybook.storyID
        currentPageID = storybook.pages[0].pageID
        previousPageID = noPage
        previousStoryText = ""
    }
    
    func update() {
        // engine update
        player.update()
    }
}
