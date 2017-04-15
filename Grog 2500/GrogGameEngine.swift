//
//  GrogGameEngine.swift
//  Grog 2500
//
//  Created by John Pavley on 4/5/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

struct GrogGameState {
    var stateID: Int
    var score: Int
    var moves: Int
    var movesGoal: Int
    var status: String
    var gameOver: Bool
    var currentPageID: Int
    
    init() {
        stateID = 0
        score = 0
        moves = 0
        movesGoal = 0
        status = ""
        gameOver = false
        currentPageID = 0
    }
}

struct GrogStoryText {
    var storyTextID: Int
    var text: String
    
    init() {
        storyTextID = 0
        text = ""
    }
}

class GrogGameEngine {
    
    // three core lists so that a story's overall state can be swapped in and out of the UI
    var storybooks = [GrogStorybook]()
    var gameStates = [GrogGameState]()
    var players = [GrogGamePlayer]()
    var storyTexts = [GrogStoryText]()
    
    // associated storybook, game state, and player all have the same ID
    var currentStorybookID: Int
    let prompt = "\n>"
    
    init(storybooks: [GrogStorybook], startStoryID: Int) {
        
        currentStorybookID = startStoryID
        
        for story in storybooks {
            
            // add the storybook to the storybooks
            self.storybooks.append(story)
            
            // create and add a game state for each storybook
            
            var gameState = GrogGameState()
            gameState.stateID = story.storyID
            gameState.score = story.budget.score
            gameState.moves = 0
            gameState.movesGoal = story.budget.moves
            gameState.status = "ready"
            gameState.gameOver = false
            gameState.currentPageID = story.pages.first!.pageID
            gameStates.append(gameState)
            
            // create and add a player for each storybook
            
            let player = GrogGamePlayer()
            player.playerID = story.storyID
            player.health = story.budget.health
            player.location = story.pages.first!.name
            players.append(player)
            
            // create and add a story text for each storybook
            var storyText = GrogStoryText()
            storyText.storyTextID = story.storyID
            storyText.text = ""
            storyTexts.append(storyText)
        }
    }
    
    func update() {
        // get all the things!
        var state = gameStates.filter { $0.stateID == currentStorybookID }.first!
        let player = players.filter { $0.playerID == currentStorybookID }.first!
        let storybook = storybooks.filter { $0.storyID == currentStorybookID }.first!
        
        player.update()
        
        if storybook.tracking {
            
            // player health management
            if player.health <= 0 {
                player.health = 0
                state.gameOver = true
                state.status = "Fail"
                state.currentPageID = storybook.endGame.failNoHealthPage
            } else if player.health >= 100 {
                player.health = 100
            }
            
            // game score management
            if state.score <= 0 {
                state.score = 0
                state.gameOver = true
                state.status = "Fail"
                state.currentPageID = storybook.endGame.failNoPointsPage
            } else if state.score >= 100 {
                if state.moves <= state.movesGoal {
                    state.currentPageID = storybook.endGame.successExtraPointsPage
                    state.gameOver = true
                    state.status = "Winning"
                } else {
                    state.gameOver = true
                    state.status = "Winning"
                    state.currentPageID = storybook.endGame.successPage
                }
            }
        }
    }
}
