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
        score = 0
        moves = 0
        movesGoal = 100
        status = "ready"
        
        player = GrogGamePlayer()
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
        
        // player health management
        if player.health <= 0 {
            player.health = 0
            print("game over: you lose, you died")
            gameOver = true
            status = "Loser"
        } else if player.health >= 100 {
            player.health = 100
        }
        
        // game score management
        if score <= 0 {
            score = 0
            print("game over")
            gameOver = true
            status = "Loser"
        } else if score >= 100 {
            if moves <= movesGoal {
                print("award extra points for hitting moves goal")
            }
            print("game over: you win on points")
            gameOver = true
            status = "Winning"
        }
        
    }
}
