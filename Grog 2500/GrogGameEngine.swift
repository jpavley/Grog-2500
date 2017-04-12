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
    }
    
    func update() {
        // engine update
        player.update()
        
        let story = storybooks.filter { $0.storyID == currentStoryID }.first!
        
        if story.tracking {
            
            // player health management
            if player.health <= 0 {
                player.health = 0
                print("game over: health <= 0")
                gameOver = true
                status = "Loser"
            } else if player.health >= 100 {
                player.health = 100
            }
            
            // game score management
            if score <= 0 {
                score = 0
                print("game over: score <= 0")
                gameOver = true
                status = "Loser"
            } else if score >= 100 {
                if moves <= movesGoal {
                    print("extra reward: moves <= movesGoal")
                }
                print("game over: score >= 100")
                gameOver = true
                status = "Winning"
            }
        }
    }
}
