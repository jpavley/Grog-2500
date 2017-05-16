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
// TODO: create a command line utility that verifies storybook data (example: each ID is unique)


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
    case lose     // only show the command if the game is over and the player loses
    // TODO: Impletement storybookComplete in GrogGameEngine
    case storybookComplete
}

struct GrogEndGame {
    let successPage: Int
    let successExtraPointsPage: Int
    let failNoHealthPage: Int
    let failNoPointsPage: Int
}

extension GrogEndGame {
    init?(json: [String: Int]) {
        guard let successPage = json["successPage"],
            let successExtraPointsPage = json["successExtraPointsPage"],
            let failNoHealthPage = json["failNoHealthPage"],
            let failNoPointsPage = json["failNoPointsPage"]
            else {
                return nil
        }
        self.successPage = successPage
        self.successExtraPointsPage = successExtraPointsPage
        self.failNoHealthPage = failNoHealthPage
        self.failNoPointsPage = failNoPointsPage
    }
}

struct GrogBudget {
    let score: Int
    let health: Int
    let moves: Int
    let extraPoints: Int
}

extension GrogBudget {
    init?(json: [String: Int]) {
        guard let score = json["score"],
            let health = json["health"],
            let moves = json["moves"],
            let extraPoints = json["extraPoints"]
            else {
                return nil
        }
        self.score = score
        self.health = health
        self.moves = moves
        self.extraPoints = extraPoints
    }
}

struct GrogGoals {
    let healthFloor: Int
    let healthCeiling: Int
    let scoreFloor: Int
    let scoreCeiling: Int
}

extension GrogGoals {
    init?(json: [String: Int]) {
        guard let healthFloor = json["healthFloor"],
            let healthCeiling = json["healthCeiling"],
            let scoreFloor = json["scoreFloor"],
            let scoreCeiling = json["scoreCeiling"]
            
            else {
                return nil
        }
        self.healthFloor = healthFloor
        self.healthCeiling = healthCeiling
        self.scoreFloor = scoreFloor
        self.scoreCeiling = scoreCeiling
    }
}

struct GrogTheme {
    let screenColor: UIColor
    let textColor: UIColor
}

extension GrogTheme {
    init?(json: [String: [Any]]) {
        guard let screenColorRGB = json["screenColor"] as? [CGFloat],
            let textColorRGB = json["textColor"] as? [CGFloat]
            else {
                return nil
        }
        let screenColor = UIColor.init(red: screenColorRGB[0],
                                       green: screenColorRGB[1],
                                       blue: screenColorRGB[2],
                                       alpha: 1.0)
        let textColor = UIColor.init(red: textColorRGB[0],
                                     green: textColorRGB[1],
                                     blue: textColorRGB[2],
                                     alpha: 1.0)
        self.screenColor = screenColor
        self.textColor = textColor
    }
}

struct GrogCommand {
    let name: String
    let commandID: Int
    let buttonID: Int
    let healthCost: Int
    let movesCost: Int
    let pointsAward: Int
    let availability: CommandAvailability
    let nextStoryID: Int
    let nextPageID: Int
    let action: StoryAction
    let nextStatus: String
}

extension GrogCommand {
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let commandID = json["commandID"] as? Int,
            let buttonIDStr = json["buttonID"] as? String,
            let healthCost = json["healthCost"] as? Int,
            let movesCost = json["movesCost"] as? Int,
            let pointsAward = json["pointsAward"] as? Int,
            let availabilityStr = json["availability"] as? String,
            let nextStoryID = json["nextStoryID"] as? Int,
            let nextPageID = json["nextPageID"] as? Int,
            let actionStr = json["action"] as? String,
            let nextStatus = json["nextStatus"] as? String
            else {
                return nil
        }
        self.name = name
        self.commandID = commandID
        
        var buttonID = noID
        switch buttonIDStr {
            
        case "r1c1": buttonID = r1c1
        case "r1c2": buttonID = r1c2
        case "r1c3": buttonID = r1c3
            
        case "r2c1": buttonID = r2c1
        case "r2c2": buttonID = r2c2
        case "r2c3": buttonID = r2c3
            
        case "r3c1": buttonID = r3c1
        case "r3c2": buttonID = r3c2
        case "r3c3": buttonID = r3c3
            
        case "r4c1": buttonID = r4c1
        case "r4c2": buttonID = r4c2
        case "r4c3": buttonID = r4c3
            
        default:
            print("Error: found unknown buttonIDStr \(buttonIDStr)")
            return nil
        }
        
        self.buttonID = buttonID
        self.healthCost = healthCost
        self.movesCost = movesCost
        self.pointsAward = pointsAward
        
        var availability:CommandAvailability = .always
        switch availabilityStr {
        case "always": availability = .always
        case "gameOver": availability = .gameOver
        case "gameOn": availability = .gameOn
        case "win": availability = .win
        case "lose": availability = .lose
        case "storybookComplete": availability = .storybookComplete
        default:
            print("Error: found unknown availabilityStr \(availabilityStr)")
            return nil
        }
        
        self.availability = availability
        self.nextStoryID = nextStoryID
        self.nextPageID = nextPageID
        
        var action:StoryAction = .clear
        switch actionStr {
        case "clear": action = .clear
        case "jump": action = .jump
        case "swap": action = .swap
        default:
            print("Error: found unknown actionStr \(actionStr)")
            return nil
        }
        
        self.action = action
        self.nextStatus = nextStatus
    }
}

struct GrogPage {
    let name: String
    let pageID: Int
    let storyText: String
    let commands: [GrogCommand]
}

extension GrogPage {
    init?(json: [String: Any], cmdDict: [Int: GrogCommand]) {
        guard let name = json["name"] as? String,
            let pageID = json["pageID"] as? Int,
            let storyText = json["storyText"] as? String,
            let commandIDs = json["commands"] as? [Int]
            else {
                return nil
        }
        self.name = name
        self.pageID = pageID
        self.storyText = storyText
        
        var commands = [GrogCommand]()
        for id in commandIDs {
            commands.append(cmdDict[id]!)
        }
        
        self.commands = commands
    }
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

extension GrogStorybook {
    
    init?(json: [String: Any]) {
        
        guard let name = json["name"] as? String,
            let storyID = json["storyID"] as? Int,
            let firstPage = json["firstPage"] as? Int,
            let tracking = json["tracking"] as? Bool,
            let pagesJSON = json["pages"] as? [Any],
            let themeJSON = json["theme"] as? [String: Any],
            let budgetJSON = json["budget"] as? [String: Int],
            let goalsJSON = json["goals"] as? [String: Int],
            let endGameJSON = json["endGame"] as? [String: Int],
            let commandsJSON = json["commands"] as? [Any]
            else {
                return nil
        }
        
        // simple properties
        
        self.name = name
        self.storyID = storyID
        self.firstPage = firstPage
        self.tracking = tracking
        
        // complex properties
        
        var commands = [Int: GrogCommand]()
        for cmdJSON in commandsJSON {
            guard let command = GrogCommand.init(json: cmdJSON as! [String : Any]) else {
                return nil
            }
            commands.updateValue(command, forKey: command.commandID)
        }
        
        var pages = [Int: GrogPage]()
        for pageJSON in pagesJSON {
            if let page = GrogPage.init(json:pageJSON as! [String : Any], cmdDict: commands) {
                pages.updateValue(page, forKey: page.pageID)
            }
        }
        
        self.pages = pages
        
        let theme = GrogTheme(json: themeJSON as! [String : [Any]])!
        let goals = GrogGoals(json: goalsJSON)!
        let budget = GrogBudget(json: budgetJSON)!
        let endGame = GrogEndGame(json: endGameJSON)!
        
        // temp values below
        self.theme = theme
        self.budget = budget
        self.goals = goals
        self.endGame = endGame
    }
}

struct GrogGame {
    let name: String
    let gameID: Int
    let firstStorybookID: Int
}

extension GrogGame {
    init?(json: [String: Any]) {
        
        guard let name = json["name"] as? String,
            let gameID = json["gameID"] as? Int,
            let firstStorybookID = json["firstStorybookID"] as? Int
            else {
                return nil
        }
        
        // simple properties
        
        self.name = name
        self.gameID = gameID
        self.firstStorybookID = firstStorybookID
    }
}
