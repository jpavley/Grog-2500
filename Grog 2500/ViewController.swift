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
    
    let r5c1 = 112
    let r5c2 = 113
    let r5c3 = 114
    
    
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
        
        if let storybooks = initStories() {
            
            // get the game and and the main storybook
            if game == nil {
                // main storybook is always the first
                game = GrogGameEngine(storybook: storybooks.first!)
                
                // if there are anyother stories just add them to the list
                let subStories = storybooks.dropFirst()
                for story in subStories {
                    game!.storybooks.append(story)
                }
            }
            
            let currentStory = game!.storybooks.filter { $0.storyID == game!.currentStoryID }.first!
            let page = currentStory.pages.filter({ $0.pageID == game!.currentPageID }).first!
            
            // update the game from storybook data
            game!.player.location = page.name
            
            // update the user interface from game and storybook data
            updateUIStatus()
            updateCommandButtons(with: page.commands)
            story.backgroundColor = currentStory.theme.screenColor
            story.textColor = currentStory.theme.textColor
            
            // if the texts overfills the screen scroll to the buttom
            let range = NSMakeRange(story.text.characters.count - 1, 1)
            story.scrollRangeToVisible(range)
            
            // TODO: Continue to have the issue were the UITextView is not scrolloing to the button
            // NOTE: Need to disable and then enable scrolling on a UITextView for proper rendering of forced scroll
            story.isScrollEnabled = false
            story.isScrollEnabled = true
        }
    }
    
    func outputToScreen() {
        // output the storybook page text
        let currentStory = game!.storybooks.filter { $0.storyID == game!.currentStoryID }.first!
        let page = currentStory.pages.filter({ $0.pageID == game!.currentPageID }).first!
        story.text = story.text + page.storyText + game!.prompt
    }
    
    func updateUIStatus() {
        score.text = "🎼 \(game!.score)"
        health.text = "💚 \(game!.player.health)%"
        time.text = "🚶‍♀️\(game!.moves)"
        status.text = "🎮 \(game!.status)"
        location.text = "🗺 \(game!.player.location)"
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
        
        let act1 = GrogAction(nextStoryID: noStory, nextPageID: 1001, action: .jump)
        let act2 = GrogAction(nextStoryID: noStory, nextPageID: 1002, action: .jump)
        let act3 = GrogAction(nextStoryID: noStory, nextPageID: 1003, action: .jump)
        let act4 = GrogAction(nextStoryID: noStory, nextPageID: 1000, action: .clear)
        let act5 = GrogAction(nextStoryID: 20, nextPageID: noPage, action: .swap)
        
        let cmd1 = GrogCommand(name: "Cat 😺", commandID: r1c1, healthCost: -2, pointsAward: -1, action: act1)
        let cmd2 = GrogCommand(name: "Switch 💡", commandID: r2c2, healthCost: -2, pointsAward: -2, action: act2)
        let cmd3 = GrogCommand(name: "Bed 🛏", commandID: r3c3, healthCost: 4, pointsAward: 4, action: act3)
        let cmd4 = GrogCommand(name: "Restart 🎬", commandID: r4c1, healthCost: 0, pointsAward: 0, action: act4)
        let cmd5 = GrogCommand(name: "Help ❓", commandID: r5c3, healthCost: 0, pointsAward: 0, action: act5)
        
        let page1 = GrogPage(name: "The Bedroom", pageID: 1000, storyText: "You are in a dark room. There is a cat on a bed, a lamp on a nightstand, and a light switch on the wall here. Maybe touching one of these things will do something interesting?", commands: [cmd1, cmd2, cmd3, cmd5])
        let page2 = GrogPage(name: "Cat Scratch", pageID: 1001, storyText: "You reach out to pet the cat but it scraches your hand with its wicked sharp claws and runs out of the room. You might want to clean that wound when you get a chance.", commands: [cmd2, cmd3, cmd5])
        let page3 = GrogPage(name: "Pop Bang", pageID: 1002, storyText: "The lamp on the nightstand glows bightly, so brightly that it expodes in a shower of sparks and the room is plunged into total darkness.", commands: [cmd3, cmd5])
        let page4 = GrogPage(name: "Back to Bed", pageID: 1003, storyText: "You crawl into bed and pull the covers over your head. It's warm and comfy. So comfy that the cat curls up to sleep on your stomach.", commands: [cmd4, cmd5])
        
        let mainStorybook = GrogStorybook(name: "Main Story", storyID: 10, pages: [page1, page2, page3, page4], theme: theme1)
        
        // Help storybook
        let theme2 = GrogTheme(screenColor: UIColor.darkGray, textColor: UIColor.white)
        
        let act6 = GrogAction(nextStoryID: 10, nextPageID: noPage, action: .swap)
        let act7 = GrogAction(nextStoryID: noStory, nextPageID: 2001, action: .jump)
        let act8 = GrogAction(nextStoryID: noStory, nextPageID: 2002, action: .jump)
        let act9 = GrogAction(nextStoryID: noStory, nextPageID: 2003, action: .jump)
        let act10 = GrogAction(nextStoryID: noStory, nextPageID: 2000, action: .jump)
        
        let cmd6 = GrogCommand(name: "Yes 👍", commandID: r5c3, healthCost: 0, pointsAward: 0, action: act6)
        let cmd7 = GrogCommand(name: "No 👎", commandID: r5c2, healthCost: 0, pointsAward: 0, action: act7)
        // TODO: Special page ID that signals just go to the next page, so that cmds can be reused
        let cmd8 = GrogCommand(name: "Go On 👂", commandID: r5c3, healthCost: 0, pointsAward: 0, action: act8)
        let cmd9 = GrogCommand(name: "Go On 👂", commandID: r5c3, healthCost: 0, pointsAward: 0, action: act9)
        let cmd10 = GrogCommand(name: "Done ✅", commandID: r5c3, healthCost: 0, pointsAward: 0, action: act10)
        
        let page5 = GrogPage(name: "Help", pageID: 2000, storyText: "Welcome to Grog 2500 my friend. It's super to meet you. Do you want to play a game?", commands: [cmd6, cmd7])
        
        // TODO: for really long text a signal that says "don't automatically scroll to the button of the screen"
        
        let page6 = GrogPage(name: "About Grog 2500", pageID: 2001, storyText: "Ah, you need a little convincing? Good! I like skeptical people! This is the story of Grog 2500, the app that's running on your phone. Back in the day, before GPUs and 4K screens, kids of all ages enjoyed playing text  games. Classic games like Adventure and Zork. You can still play these games, with emulation.", commands: [cmd8])
        let page7 = GrogPage(name: "About Grog 2500", pageID: 2002, storyText: "But truly new 21st centry text games have not come into being, even though people are reading and typing more than ever before. Social media and messaging apps have become so ubuquious that life itself has become one big text game.", commands: [cmd9])
        let page8 = GrogPage(name: "About Grog 2500", pageID: 2003, storyText: "So we, the author behind Grog 2500, decided it was time to update the old text adventure game paradigm for the modern age, with emojis, verticality, and an interaction style designed for the phone. That's about it. Go run along and play nice now.", commands: [cmd10])


        let helpStorybook = GrogStorybook(name: "Help Story", storyID: 20, pages: [page5, page6, page7, page8], theme: theme2)
        
        return [mainStorybook, helpStorybook]
        
    }
    
    // system functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUI()
        outputToScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button functions
    
    @IBAction func commandButton(_ sender: Any) {
        
        let buttonID = (sender as AnyObject).tag!
        let currentStory = game!.storybooks.filter { $0.storyID == game!.currentStoryID }.first!
        let page = currentStory.pages.filter { $0.pageID == game!.currentPageID }.first!
        
        // get the commend based on button press
        let commandList = page.commands
        let cmd = commandList.filter { $0.commandID == buttonID }.first!
        
        // update game and player data
        game!.player.health += cmd.healthCost
        game!.score += cmd.pointsAward
        game!.moves += 1
        game!.status = "playing"
        
        switch cmd.action.action {
        case .clear:
            
            // clear the output
            story.text = ""
            
            // restart the game
            game = nil
            loadUI()
            outputToScreen()
            
        case .jump:
            
            // output the label
            let buttonLabel = (sender as! UIButton).titleLabel!.text!
            story.text = story.text + " \(buttonLabel) \n"
            
            // go to the next page
            let nextPage = currentStory.pages.filter { $0.pageID == cmd.action.nextPageID }.first!
            game!.currentPageID = nextPage.pageID
            loadUI()
            outputToScreen()
            
        case .swap:
            
            // temporarily save the current page ID to use as the previous page ID (later)
            let savedCurrentPageID = game!.currentPageID
            
            // save the current story text to use as the previous story text (later)
            let savedStoryText = story.text!
            
            // set the current story ID the command's next story ID
            game!.currentStoryID = cmd.action.nextStoryID
            
            // if the previous page ID was not saved before then just go the first page of the next story
            // otherwise set the previous page ID as the current page ID
            if game!.previousPageID == noPage {
                let nextStory = game!.storybooks.filter { $0.storyID == game!.currentStoryID }.first!
                game!.currentPageID = nextStory.pages.first!.pageID
            } else {
                game!.currentPageID = game!.previousPageID
            }
            
            // now its safe to store the original current page ID as the previous page ID
            game!.previousPageID = savedCurrentPageID
            
            // if there is previous story text then disable printing to the screen
            let dontPrint = (game!.previousStoryText != "")
            
            // restore the original previous story text and then update the previous story text to the saved story text from above
            story.text = game!.previousStoryText
            game!.previousStoryText = savedStoryText
            
            // load the UI and output the story
            loadUI()
            
            if !dontPrint {
                outputToScreen()
            }
        }
    }
}

