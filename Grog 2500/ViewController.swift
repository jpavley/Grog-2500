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
    var currentGameFileName = "MainMenu"
    
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
    
    // TODO: Implement an animated loading screen
    // TODO: Create a game store
    // TODO: Synch local and remote games (in the case of updates)
    // TODO: Create an game editor app
    // TODO: Add sound effects
    // TODO: Add animation effects
    // TODO: Move all the game logic out of this here ViewController and into the Game Engine
    // TODO: Only game name and page name are used, storybook name is not used by UI. Is this good, bad, or not a big deal?
    // TODO: Create a game registration table
    
    // UI functions
    
    func loadUI(with filename: String) {
        
        if game == nil {
            let (storybooks, gameData) = initLocalStory(fileName: filename)
            if storybooks != nil && gameData != nil {
                game = GrogGameEngine(storybooks: storybooks!, game: gameData!)
            }

        }
        
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        
        // update the user interface from game and storybook data
        game!.movePlayer()
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
    
    func updateUIStatus() {
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        
        // TODO: Not hiding UI with test game one's help storybook
        trackedUI(show: !storybook.tracking)
        
        if storybook.tracking {
            let state = game!.gameStates[game!.currentStorybookID]!

            score.text = "🎼 \(state.score)"
            updateHealthUI()
            time.text = "🚶‍♀️\(state.moves)/\(state.movesGoal)"
            status.text = "🎮 \(state.status)"
        }
        
        updateLocationUI()
    }
    
    func trackedUI(show: Bool) {
        score.isHidden = show
        health.isHidden = show
        time.isHidden = show
        status.isHidden = show
    }
    
    func updateLocationUI() {
        let player = game!.players[game!.currentStorybookID]!
        location.text = "🗺 \(game!.currentGameName): \(player.location)"
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
            if showCommand(availability: cmd.availability) {
                let btn = view.viewWithTag(cmd.buttonID) as! UIButton
                btn.setTitle(cmd.name, for: .normal)
                btn.isEnabled = true
                btn.backgroundColor = UIColor.clear
                btn.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    func showCommand(availability: CommandAvailability) -> Bool {
        // get all the things
        let state = game!.gameStates[game!.currentStorybookID]!
        let storybook = game!.storybooks[game!.currentStorybookID]!
                
        switch availability {
        case .always:
            return true
        case .gameOn:
            return !game!.gameOver
        case .gameOver:
            return game!.gameOver
        case .lose:
            return state.score <= storybook.goals.scoreFloor
        case .win:
            return state.score >= storybook.goals.scoreCeiling
        case .storybookComplete:
            return state.storybookComplete
        }
    }
    
    func renderView() {
        loadUI(with: currentGameFileName)
        updateTheme()
        game!.calcStoryText()
        outputToScreen()

    }
    
    // system functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        renderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button functions
    
    @IBAction func commandButton(_ sender: Any) {
        // get all the things!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        let buttonID = (sender as AnyObject).tag!
        
        // get the commend based on button press
        let commandList = page.commands
        let cmd = commandList.filter { $0.buttonID == buttonID }.first
        
        if cmd != nil {
            let cmdAction = cmd!.action
            switch cmdAction {
                
            case .clear:
                clearGame(cmd: cmd!)
                
            case .jump:
                jumpPage(sender: sender, cmd: cmd!)
                
            case .swap:
                swapStory(cmd: cmd!)
            case .load:
                loadGame(cmd: cmd!)
            }
        }else {
            print("cmd \(buttonID) does not exist on page \(page.pageID)")
        }
    }
    
    func clearGame(cmd: GrogCommand) {
        game!.clearGame(cmd: cmd)
        
        // restart the game
        game = nil
        renderView()
    }
    
    func jumpPage(sender: Any, cmd: GrogCommand) {
        
        // what page are we on based on cmd?
        game!.calcCurrentPage(cmd: cmd)
        
        // Get all the things! (now that we know the current page)
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let buttonLabel = (sender as! UIButton).titleLabel!.text!
        
        // do the jump! (game could be over based on jump)
        game!.jumpPage(buttonLabel: buttonLabel, cmd: cmd)
        
        // after an update the story might have changed!
        // FIXME: this is a bit of game logic
        if storybook.tracking && game!.gameOver {
            
            // local update if needed to display that the game is over
            let newText = " 🎲 \n"
            game!.updateStoryText(newText: newText)
            let storyText = game!.storyTexts[game!.currentStorybookID]!
            story.text = storyText
            renderView()
        } else {
            // load the UI and out the text
            loadUI(with: currentGameFileName)
            updateTheme()
            outputToScreen()
        }
    }
        
    func swapStory(cmd: GrogCommand) {

        game!.swapStory(cmd: cmd)
        
        // get all the things!
        let storyText = game!.storyTexts[game!.currentStorybookID]!
        let storybook = game!.storybooks[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!
        let page = storybook.pages[state.currentPageID]!
        
        // local update if the story has not started
        if storyText == "" {
            game!.calcStoryText()
        }
        
        updateLocationUI()
        
        // load the UI and output the story
        if storybook.tracking {
            loadUI(with: currentGameFileName)
        } else {
            updateCommandButtons(with: page.commands)
        }
        updateTheme()
        outputToScreen()
        
    }
    
    func loadGame(cmd: GrogCommand) {
        game!.loadGame(cmd: cmd)
        
        if let nextGameFileName = game!.gameFileName(for: cmd.nextGameID) {
            currentGameFileName = nextGameFileName
        }
        
        // restart the new game
        game = nil
        renderView()
    }
}

