//
//  GrogStorybook.swift
//  Grog 2500
//
//  Created by John Pavley on 4/6/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation
import UIKit

let noPage = -1
let noStory = -1
let noBudget = -1

enum StoryAction {
    case jump   // jump from current storybook page to a different page in the same storybook
    case clear  // restart the current storybook
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
}

struct GrogCommand {
    let name: String
    let commandID: Int
    let healthCost: Int
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
    let pages: [GrogPage]
    let theme: GrogTheme
    let budget: GrogBudget
    let endGame: GrogEndGame
    let tracking: Bool
}
