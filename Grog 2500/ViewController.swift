//
//  ViewController.swift
//  Grog 2500
//
//  Created by John Pavley on 4/4/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    // UI functions
    
    func loadUI() {
        
        if game == nil {
            if let storybooks = initStories() {
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
        let player = game!.players[game!.currentStorybookID]!
        let state = game!.gameStates[game!.currentStorybookID]!

        score.text = "🎼 \(state.score)"
        updateHealthUI()
        time.text = "🚶‍♀️\(state.moves)/\(state.movesGoal)"
        status.text = "🎮 \(state.status)"
        location.text = "🗺 \(player.location)"
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
    
    func initStories() -> [GrogStorybook]? {
        
        // Main storybook
        let theme1 = GrogTheme(screenColor: UIColor.blue, textColor: UIColor.cyan)
        
        let act1 = GrogAction(nextStoryID: noStory, nextPageID: 1001, action: .jump, nextStatus: "playing")
        let act2 = GrogAction(nextStoryID: noStory, nextPageID: 1002, action: .jump, nextStatus: "playing")
        let act3 = GrogAction(nextStoryID: noStory, nextPageID: 1003, action: .jump, nextStatus: "playing")
        let act11 = GrogAction(nextStoryID: noStory, nextPageID: 1008, action: .jump, nextStatus: "playing")
        let act4 = GrogAction(nextStoryID: noStory, nextPageID: 1000, action: .clear, nextStatus: "ready")
        let act5 = GrogAction(nextStoryID: 20, nextPageID: noPage, action: .swap, nextStatus: "paused")
        
        let cmd1 = GrogCommand(name: "Cat 😺", commandID: r1c1, healthCost: -50, pointsAward: -10, action: act1)
        let cmd2 = GrogCommand(name: "Switch 💡", commandID: r1c2, healthCost: -50, pointsAward: -20, action: act2)
        let cmd3 = GrogCommand(name: "Bed 🛏", commandID: r1c3, healthCost: 10, pointsAward: 110, action: act3)
        let cmd11 = GrogCommand(name: "Think 🤔", commandID: r2c2, healthCost: 20, pointsAward: 40, action: act11)
        let cmd4 = GrogCommand(name: "Restart 🎬", commandID: r4c1, healthCost: 0, pointsAward: 0, action: act4)
        let cmd5 = GrogCommand(name: "Help ❓", commandID: r4c3, healthCost: 0, pointsAward: 0, action: act5)
        
        let page1 = GrogPage(name: "The Bedroom", pageID: 1000, storyText: "You are in a dark room. There is a cat on a bed, a lamp on a nightstand, and a light switch on the wall. Maybe touching one of these things will do something interesting?", commands: [cmd1, cmd2, cmd3, cmd5, cmd11])
        let page2 = GrogPage(name: "Cat Scratch", pageID: 1001, storyText: "You reach out to pet the cat but it scraches your hand with its wicked sharp claws and runs out of the room. You might want to clean that wound when you get a chance.", commands: [cmd2, cmd3, cmd4, cmd5])
        let page3 = GrogPage(name: "Pop Bang", pageID: 1002, storyText: "The lamp on the nightstand glows bightly, so brightly that it expodes in a shower of sparks and the room is plunged into total darkness.", commands: [cmd1, cmd3, cmd4, cmd5])
        let page4 = GrogPage(name: "Back to Bed", pageID: 1003, storyText: "You crawl into bed and pull the covers over your head. It's warm and comfy. So comfy that the cat curls up to sleep on your stomach.", commands: [cmd1, cmd2, cmd4, cmd5])
        let page13 = GrogPage(name: "Thinking Thoughtfully", pageID: 1008, storyText: "Hmmm... The cat looks cute but dangerious. The light switch looks a little dodgy. The bed looks comfy.", commands: [cmd1, cmd2, cmd3, cmd5])
        let page9 = GrogPage(name: "You're a Winner", pageID: 1004, storyText: "You've won the game by going back to bed. Nice work!", commands: [cmd4, cmd5])
        let page10 = GrogPage(name: "You're a Winner", pageID: 1005, storyText: "You've won the game by going back to bed. And you made the decision quickly so you get extra points! Good Job!", commands: [cmd4, cmd5])
        let page11 = GrogPage(name: "You're a Loser", pageID: 1006, storyText: "You've lost the game because you have died. You're health is 0%. Better luck next time.", commands: [cmd4, cmd5])
        let page12 = GrogPage(name: "You're a Loser", pageID: 1007, storyText: "You've lost the game because you ran out of points. You're health is 0%. Maybe you should make better choices", commands: [cmd4, cmd5])
        
        let budget1 = GrogBudget(score: 50, health: 50, moves: 1)
        let endgame1 = GrogEndGame(successPage: 1004, successExtraPointsPage: 1005, failNoHealthPage: 1006, failNoPointsPage: 1007)
        
        let mainPages = [
            page1.pageID : page1,
            page2.pageID : page2,
            page3.pageID : page3,
            page4.pageID : page4,
            page13.pageID : page13,
            page9.pageID : page9,
            page10.pageID : page10,
            page11.pageID : page11,
            page12.pageID : page12,
        ]
        
        let mainStorybook = GrogStorybook(name: "Main Story", storyID: 10, pages: mainPages, firstPage: 1000, theme: theme1, budget: budget1, endGame: endgame1, tracking: true)
        
        // Help storybook
        let theme2 = GrogTheme(screenColor: UIColor.darkGray, textColor: UIColor.white)
        
        let act6 = GrogAction(nextStoryID: 10, nextPageID: noPage, action: .swap, nextStatus: "paused")
        let act7 = GrogAction(nextStoryID: noStory, nextPageID: 2001, action: .jump, nextStatus: "paused")
        let act8 = GrogAction(nextStoryID: noStory, nextPageID: 2002, action: .jump, nextStatus: "paused")
        let act9 = GrogAction(nextStoryID: noStory, nextPageID: 2003, action: .jump, nextStatus: "paused")
        let act10 = GrogAction(nextStoryID: 10, nextPageID: noPage, action: .swap, nextStatus: "playing")
        
        let cmd6 = GrogCommand(name: "Yes 👍", commandID: r4c3, healthCost: 0, pointsAward: 0, action: act6)
        let cmd7 = GrogCommand(name: "No 👎", commandID: r4c2, healthCost: 0, pointsAward: 0, action: act7)
        let cmd8 = GrogCommand(name: "Go On 👂", commandID: r4c3, healthCost: 0, pointsAward: 0, action: act8)
        let cmd9 = GrogCommand(name: "Go On 👂", commandID: r4c3, healthCost: 0, pointsAward: 0, action: act9)
        let cmd10 = GrogCommand(name: "Done ✅", commandID: r4c3, healthCost: 0, pointsAward: 0, action: act10)
        
        let page5 = GrogPage(name: "Help", pageID: 2000, storyText: "Welcome to Grog 2500 my friend. It's super to meet you. Do you want to play a game?", commands: [cmd6, cmd7])
        
        let page6 = GrogPage(name: "About Grog 2500", pageID: 2001, storyText: "Ah, you need a little convincing? Good! I like skeptical people! This is the story of Grog 2500, the app that's running on your phone. Back in the day, before GPUs and 4K screens, kids of all ages enjoyed playing text  games. Classic games like Adventure and Zork. You can still play these games, with emulation.", commands: [cmd8])
        let page7 = GrogPage(name: "About Grog 2500", pageID: 2002, storyText: "But truly new 21st centry text games have not come into being, even though people are reading and typing more than ever before. Social media and messaging apps have become so ubuquious that life itself has become one big text game.", commands: [cmd9])
        let page8 = GrogPage(name: "About Grog 2500", pageID: 2003, storyText: "So we, the author behind Grog 2500, decided it was time to update the old text adventure game paradigm for the modern age, with emojis, verticality, and an interaction style designed for the phone. That's about it. Go run along and play nice now.", commands: [cmd10])
        
        let budget2 = GrogBudget(score: noBudget, health: noBudget, moves: noBudget)
        let endgame2 = GrogEndGame(successPage: noPage, successExtraPointsPage: noPage, failNoHealthPage: noPage, failNoPointsPage: noPage)
        
        let helpPages = [
            page5.pageID : page5,
            page6.pageID : page6,
            page7.pageID : page7,
            page8.pageID : page8,
        ]
        
        let helpStorybook = GrogStorybook(name: "Help Story", storyID: 20, pages: helpPages, firstPage: 2000, theme: theme2, budget: budget2, endGame: endgame2, tracking: false)
        
        return [mainStorybook, helpStorybook]
        
    }
    
    // system functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUI()
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
            calcStoryText()
            outputToScreen()
        }
    }
        
    func swapStory(cmd: GrogCommand) {
        
        // TODO: Moves are being counted in .swaping!
        // TODO: Status UI is not propertly updated in .swaping! (for a non-tracked story)
        // TODO: Story text not updated propertly in .swapping! (need to track the current page for each story!)
        
        game!.currentStorybookID = cmd.action.nextStoryID
        
        // load the UI and output the story
        loadUI()
        
        outputToScreen()
        
    }
}

