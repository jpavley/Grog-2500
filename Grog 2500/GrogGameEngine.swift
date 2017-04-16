//
//  GrogGameEngine.swift
//  Grog 2500
//
//  Created by John Pavley on 4/5/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

typealias GrogStoryID = Int
typealias GrogStoryBackingStore = String

let noID = -1
let noValue = -1

struct GrogGameState {
    var stateID: GrogStoryID
    var score: Int
    var moves: Int
    var movesGoal: Int
    var status: String
    var gameOver: Bool
    var currentPageID: GrogStoryID
    
    init() {
        stateID = noID
        score = noValue
        moves = noValue
        movesGoal = noValue
        status = ""
        gameOver = false
        currentPageID = noPage
    }
}

class GrogGameEngine {
    
    // core dictionaries so that a story's overall state can be swapped in and out of the UI
    var storybooks = [GrogStoryID:GrogStorybook]()
    var players    = [GrogStoryID:GrogGamePlayer]()
    var gameStates = [GrogStoryID:GrogGameState]()
    var storyTexts = [GrogStoryID:GrogStoryBackingStore]()
    
    // associated storybook, game state, and player all have the same ID
    var currentStorybookID: GrogStoryID
    let prompt = "\n>"
    
    init(storybooks: [GrogStorybook], startStoryID: GrogStoryID) {
        
        currentStorybookID = startStoryID
        
        for storybook in storybooks {
            
            // add the storybook to the storybooks
            self.storybooks.updateValue(storybook, forKey: storybook.storyID)
            
            // create and add a game state for each storybook
            
            var gameState = GrogGameState()
            gameState.stateID = storybook.storyID
            gameState.score = storybook.budget.score
            gameState.moves = 0
            gameState.movesGoal = storybook.budget.moves
            gameState.status = "ready"
            gameState.gameOver = false
            gameState.currentPageID = storybook.firstPage
            gameStates.updateValue(gameState, forKey: storybook.storyID)
            
            // create and add a player for each storybook
            
            var player = GrogGamePlayer()
            player.playerID = storybook.storyID
            player.health = storybook.budget.health
            player.location = storybook.pages[gameState.currentPageID]!.name
            players.updateValue(player, forKey: storybook.storyID)
            
            // create and add a story text for each storybook
            storyTexts = [currentStorybookID:""]
        }
    }
    
    func update() {
        // get all the things!
        var state = gameStates[currentStorybookID]!
        var player = players[currentStorybookID]!
        let storybook = storybooks[currentStorybookID]!
        
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
            
            gameStates.updateValue(state, forKey: currentStorybookID)
            players.updateValue(player, forKey: currentStorybookID)
        }
    }
}
