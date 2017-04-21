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


struct GrogGameState {
    var stateID: GrogStoryID
    var score: Int
    var moves: Int
    var movesGoal: Int
    var status: String
    var storybookComplete: Bool
    var currentPageID: GrogStoryID
    
    init() {
        stateID = noID
        score = noValue
        moves = noValue
        movesGoal = noValue
        status = ""
        storybookComplete = false
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
    var gameOver: Bool
    let prompt = "\n>"
    
    init(storybooks: [GrogStorybook], startStoryID: GrogStoryID) {
        
        currentStorybookID = startStoryID
        gameOver = false
        
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
            gameState.storybookComplete = false
            gameState.currentPageID = storybook.firstPage
            gameStates.updateValue(gameState, forKey: storybook.storyID)
            
            // create and add a player for each storybook
            
            var player = GrogGamePlayer()
            player.playerID = storybook.storyID
            player.health = storybook.budget.health
            player.location = storybook.pages[gameState.currentPageID]!.name
            players.updateValue(player, forKey: storybook.storyID)
            
            // create and add a story text for each storybook
            storyTexts.updateValue("", forKey: storybook.storyID)
        }
    }
    
    func movePlayer() {
        // get all the things!
        var player = players[currentStorybookID]!
        let storybook = storybooks[currentStorybookID]!
        let state = gameStates[currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        
        player.location = page.name
        players.updateValue(player, forKey:currentStorybookID)
    }
    
    func update() {
        // get all the things!
        var state = gameStates[currentStorybookID]!
        var player = players[currentStorybookID]!
        let storybook = storybooks[currentStorybookID]!
        let goals = storybook.goals
        
        player.update()
        
        if storybook.tracking {
            
            // player health management
            if player.health <= goals.healthFloor {
                player.health = goals.healthFloor
                gameOver = true
                state.storybookComplete = true
                state.status = "Fail"
                state.currentPageID = storybook.endGame.failNoHealthPage
            } else if player.health >= goals.healthCeiling {
                player.health = goals.healthCeiling
            }
            
            // game score management
            if state.score <= goals.scoreFloor {
                state.score = goals.scoreFloor
                gameOver = true
                state.storybookComplete = true
                state.status = "Fail"
                state.currentPageID = storybook.endGame.failNoPointsPage
            } else if state.score >= goals.scoreCeiling {
                if state.moves <= state.movesGoal {
                    state.currentPageID = storybook.endGame.successExtraPointsPage
                    gameOver = true
                    state.storybookComplete = true
                    state.status = "Winning"
                } else {
                    gameOver = true
                    state.storybookComplete = true
                    state.status = "Winning"
                    state.currentPageID = storybook.endGame.successPage
                }
            }
            
            gameStates.updateValue(state, forKey: currentStorybookID)
            players.updateValue(player, forKey: currentStorybookID)
        }
    }
}
