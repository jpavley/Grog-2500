//
//  GrogStorybook.swift
//  Grog 2500
//
//  Created by John Pavley on 4/6/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

let doneButtonID = 119
let noPage = -1

enum StoryAction {
    case jump   // jump from current storybook page to a different page in the same storybook
    case clear  // restart the current storybook
    case swap   // jump from the current storybook to the current page in a different storybook
}

struct GrogCommand {
    let name: String
    let commandID: Int
    var nextPageID: Int
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
