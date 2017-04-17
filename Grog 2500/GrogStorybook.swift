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


enum StoryAction {
    case jump   // jump from current storybook page to a different page in the same storybook
    case clear  // restart the current game and storybooks
    case swap   // jump from the current storybook to the current page in a different storybook
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
    let endGame: GrogEndGame
    let tracking: Bool         // Don't update stats if false
}
