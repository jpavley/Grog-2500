//
//  GrogStorybook.swift
//  Grog 2500
//
//  Created by John Pavley on 4/6/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation
import UIKit

// constants for uninitalized data

let noPage = -1
let noStory = -1
let noBudget = -1
let noStatus = ""
let noPlayer = -1
let noID = -1
let noValue = -1

// constants for command button tags/IDs

let r1c1 = 100
let r1c2 = 101
let r1c3 = 102

let r2c1 = 103
let r2c2 = 104
let r2c3 = 105

let r3c1 = 106
let r3c2 = 107
let r3c3 = 108

let r4c1 = 109
let r4c2 = 110
let r4c3 = 111


// TODO: create the ability to lock and unlock storybooks
// TODO: reasonable defaults so not all fields need initialization


enum StoryAction {
    case jump   // jump from current storybook page to a different page in the same or another storybook
    case clear  // restart the current game and storybooks
    case swap   // jump from the current storybook to the current page in a different storybook
}

enum CommandAvailability {
    case always   // always show the command regardless of the state of the game (default)
    case gameOver // only show the commend when the game is over
    case gameOn   // only show the command when the game is in progress
    case win      // only show the command if the game is over and the player wins
    case lose     // onlu show the command if the game is over and the player loses
    case storybookComplete
}

struct GrogEndGame {
    let successPage: Int
    let successExtraPointsPage: Int
    let failNoHealthPage: Int
    let failNoPointsPage: Int
}

struct GrogBudget {
    let score: Int
    let health: Int
    let moves: Int
}

struct GrogGoals {
    let healthFloor = 0
    let healthCeiling = 100
    let scoreFloor = 0
    let scoreCeiling = 100
}

struct GrogTheme {
    let screenColor: UIColor
    let textColor: UIColor
}

struct GrogAction {
    let nextStoryID: Int
    let nextPageID: Int
    let action: StoryAction
    let nextStatus: String
}

struct GrogCommand {
    let name: String
    let commandID: Int
    let healthCost: Int
    let movesCost: Int
    let pointsAward: Int
    let availability: CommandAvailability
    let action: GrogAction
}

struct GrogPage {
    let name: String
    let pageID: Int
    let storyText: String
    let commands: [GrogCommand]
    
}

struct GrogStorybook {
    let name: String
    let storyID: Int
    let pages: [Int:GrogPage]
    let firstPage: Int
    let theme: GrogTheme
    let budget: GrogBudget
    let goals: GrogGoals
    let endGame: GrogEndGame
    let tracking: Bool         // Don't update stats if false
}
