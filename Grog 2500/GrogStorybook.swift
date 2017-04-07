//
//  GrogStorybook.swift
//  Grog 2500
//
//  Created by John Pavley on 4/6/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

enum StoryAction {
    case jump, clear, noop
}

struct GrogCommand {
    let name: String
    let commandID: Int
    let nextPageID: Int
    let healthCost: Int
    let pointsAward: Int
    let action: StoryAction
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
}
