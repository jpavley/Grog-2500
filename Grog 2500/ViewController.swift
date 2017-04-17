//
//  ViewController.swift
//  Grog 2500
//
//  Created by John Pavley on 4/4/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    // by convention the starting and main storybook ID is 10
    let startStoryID = 10
    
    // user labels
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var health: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var story: UITextView!
    
    // action buttons
    
    @IBOutlet var actionButtonCollection: [UIButton]!
    
    // game vars
    var game: GrogGameEngine?
    
    // TODO: Create a game store
    // TODO: Save and load game to and from local device storage
    // TODO: Synch local and remote games (in the case of updates)
    // TODO: Create an app and document icons
    // TODO: Add sound effects
    // TODO: Add animation effects
    
    // UI functions
    
    func loadUI() {
        
        if game == nil {
            if let storybooks = initTestStoryOne() {
                game = GrogGameEngine(storybooks: storybooks, startStoryID: startStoryID)
            }
        }
        
        // get all the things!
        var player = game!.players[game!.currentStorybookID]!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        
        // update the game from storybook data
        player.location = page.name
        game!.players.updateValue(player, forKey: game!.currentStorybookID)
        
        // update the user interface from game and storybook data
        updateUIStatus()
        
        updateCommandButtons(with: page.commands)
    }
    
    func updateTheme() {
        let storybook = game!.storybooks[game!.currentStorybookID]!
        story.backgroundColor = storybook.theme.screenColor
        story.textColor = storybook.theme.textColor
    }
    
    func outputToScreen() {
        // get all the things!
        let storyText = game!.storyTexts[game!.currentStorybookID]!
        
        // output the storybook page text
        story.text = storyText
        
        // if the texts overfills the screen scroll to the buttom
        let range = NSMakeRange(story.text.characters.count + 100, 1)
        story.scrollRangeToVisible(range)
        
        // NOTE: Need to disable and then enable scrolling on a UITextView for proper rendering of forced scroll
        story.isScrollEnabled = false
        story.isScrollEnabled = true
        
    }
    
    func calcStoryText() {
        // get all the things!
        var storyText = game!.storyTexts[game!.currentStorybookID]!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!

        // Add the ouput to the storyText associated with this story and update
        storyText += page.storyText + game!.prompt
        game!.storyTexts.updateValue(storyText, forKey: game!.currentStorybookID)
    }
    
    func updateUIStatus() {
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        
        if storybook.tracking {
            let player = game!.players[game!.currentStorybookID]!
            let state = game!.gameStates[game!.currentStorybookID]!

            score.text = "🎼 \(state.score)"
            updateHealthUI()
            time.text = "🚶‍♀️\(state.moves)/\(state.movesGoal)"
            status.text = "🎮 \(state.status)"
            location.text = "🗺 \(player.location)"
        }
    }
    
    func updateHealthUI() {
        // get all the things!
        let player = game!.players[game!.currentStorybookID]!
        
        var heart:String
        
        switch player.health {
        case 0...10:
            heart = "🖤"
        case 11...20:
            heart = "💔"
        case 21...30:
            heart = "❤️"
        case 31...40:
            heart = "💛"
        case 41...50:
            heart = "💚"
        case 51...80:
            heart = "💙"
        case 81...100:
            heart = "💜"
        default:
            heart = "🖤"
        }
        
        health.text = "\(heart) \(player.health)%"
    }
    
    func updateCommandButtons(with commandList:[GrogCommand]) {
        
        // clear
        for actionButton in actionButtonCollection {
            actionButton.setTitle("", for: .normal)
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor.clear
        }
        
        // map
        for cmd in commandList {
            let btn = view.viewWithTag(cmd.commandID) as! UIButton
            btn.setTitle(cmd.name, for: .normal)
            btn.isEnabled = true
            btn.backgroundColor = UIColor.clear
            btn.setTitleColor(UIColor.black, for: .normal)
        }
    }
        
    // system functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUI()
        updateTheme()
        calcStoryText()
        outputToScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button functions
    
    @IBAction func commandButton(_ sender: Any) {
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        var state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        var player = game!.players[game!.currentStorybookID]!
        let buttonID = (sender as AnyObject).tag!
        
        // get the commend based on button press
        let commandList = page.commands
        let cmd = commandList.filter { $0.commandID == buttonID }.first!
        
        // update game and player data
        if storybook.tracking {
            player.health += cmd.healthCost
            state.score += cmd.pointsAward
            state.moves += 1
        }
        
        // keep the game engine updated!
        game!.players.updateValue(player, forKey: game!.currentStorybookID)
        game!.gameStates.updateValue(state, forKey: game!.currentStorybookID)
        
        switch cmd.action.action {
            
        case .clear:
            clearGame()
            
        case .jump:
            jumpPage(sender: sender, cmd: cmd)
            
        case .swap:
            swapStory(cmd: cmd)
        }
    }
    
    func clearGame() {
        // clear the output
        story.text = ""
        
        // restart the game
        game = nil
        
        loadUI()
        updateTheme()
        calcStoryText()
        outputToScreen()
    }
    
    func jumpPage(sender: Any, cmd: GrogCommand) {
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        var storyText = game!.storyTexts[game!.currentStorybookID]!
        var state = game!.gameStates[game!.currentStorybookID]!
        let nextPage = storybook.pages[cmd.action.nextPageID]!
        let buttonLabel = (sender as! UIButton).titleLabel!.text!
        
        // local update to the story text to display the command touched
        storyText += " \(buttonLabel) \n"
        game!.storyTexts.updateValue(storyText, forKey: game!.currentStorybookID)
        story.text = storyText
        
        // update to the next page and status
        state.currentPageID = nextPage.pageID
        state.status = cmd.action.nextStatus
        game!.gameStates.updateValue(state, forKey: game!.currentStorybookID)

        
        // load the UI and output the story for the next page
        loadUI()
        updateTheme()
        calcStoryText()
        outputToScreen()
        
        // update the game and check for game over
        game!.update()
        
        // after an update the state/story might have changed!
        let updatedState = game!.gameStates[game!.currentStorybookID]!
        var updatedStoryText = game!.storyTexts[game!.currentStorybookID]!
        
        if storybook.tracking && updatedState.gameOver {
            
            // local update if needed to display that the game is over
            updatedStoryText += " 🎲 \n"
            game!.storyTexts.updateValue(updatedStoryText, forKey: game!.currentStorybookID)
            story.text = storyText
            
            loadUI()
            updateTheme()
            calcStoryText()
            outputToScreen()
        }
    }
        
    func swapStory(cmd: GrogCommand) {
        
        game!.currentStorybookID = cmd.action.nextStoryID
        
        // get all the things!
        var storyText = game!.storyTexts[game!.currentStorybookID]!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        
        // local update if the story has not started
        if storyText == "" {
            storyText += page.storyText + game!.prompt
            game!.storyTexts.updateValue(storyText, forKey: game!.currentStorybookID)
        }
        
        print("\(storybook.name) tracking: \(storybook.tracking)")
        
        // load the UI and output the story
        if storybook.tracking {
            loadUI()
        } else {
            updateCommandButtons(with: page.commands)
        }
        updateTheme()
        outputToScreen()
        
    }
}

