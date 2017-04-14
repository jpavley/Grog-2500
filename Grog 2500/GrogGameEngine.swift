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
    var movesGoal: Int
    var status: String
    var player: GrogGamePlayer
    var gameOver: Bool
    
    var storybooks = [GrogStorybook]()
    var currentStoryID: Int
    var currentPageID: Int
    var previousPageID: Int
    var previousStoryText: String
    var previousStatus: String
    
    let prompt = "\n>"
    
    init(storybook: GrogStorybook) {
        score = storybook.budget.score
        moves = 0
        movesGoal = storybook.budget.moves
        status = "ready"
        
        player = GrogGamePlayer()
        player.health = storybook.budget.health
        gameOver = false
        
        storybooks.append(storybook)
        currentStoryID = storybook.storyID
        currentPageID = storybook.pages[0].pageID
        previousPageID = noPage
        previousStoryText = ""
        previousStatus = ""
    }
    
    func update() {
        // engine update
        player.update()
        
        let story = storybooks.filter { $0.storyID == currentStoryID }.first!
        
        if story.tracking {
            
            // player health management
            if player.health <= 0 {
                player.health = 0
                gameOver = true
                status = "Fail"
                currentPageID = story.endGame.failNoHealthPage
            } else if player.health >= 100 {
                player.health = 100
            }
            
            // game score management
            if score <= 0 {
                score = 0
                gameOver = true
                status = "Fail"
                currentPageID = story.endGame.failNoPointsPage
            } else if score >= 100 {
                if moves <= movesGoal {
                    currentPageID = story.endGame.successExtraPointsPage
                    gameOver = true
                    status = "Winning"
                } else {
                    gameOver = true
                    status = "Winning"
                    currentPageID = story.endGame.successPage
                }
            }
        }
    }
}
