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
            
            // output the storybook page text
            story.text = story.text + page.storyText + game!.prompt
            
            // TODO: Scroll to the bottom is broken when emojis are added
            
            // if the texts overfills the screen scroll to the buttom
            //            let range = NSMakeRange(story.text.characters.count - 1, 1)
            //            story.scrollRangeToVisible(range)
            
        }
    }
    
    func updateUIStatus() {
        score.text = "🎼 \(game!.score)"
        health.text = "💚 \(game!.player.health)%"
        time.text = "🚶‍♀️\(game!.moves)"
        status.text = "🎮 \(game!.status)"
        location.text = "🗺 \(game!.player.location)"
    }
    
    func updateCommandButtons(with commandList:[GrogCommand]) {
        
        // TODO: Buttons width not log engough when emojis are added to button labels
        
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
        
        let cmd1 = GrogCommand(name: "Cat 😺", commandID: r1c1, nextPageID: 1001, healthCost: -2, pointsAward: -1, action: .jump)
        let cmd2 = GrogCommand(name: "Switch 💡", commandID: r2c2, nextPageID: 1002, healthCost: -2, pointsAward: -2, action: .jump)
        let cmd3 = GrogCommand(name: "Bed 🛏", commandID: r3c3, nextPageID: 1003, healthCost: 4, pointsAward: 4, action: .jump)
        let cmd4 = GrogCommand(name: "Restart 🎬", commandID: r4c1, nextPageID: 1000, healthCost: 0, pointsAward: 0, action: .clear)
        let cmd5 = GrogCommand(name: "Help ❓", commandID: r5c3, nextPageID: noPage, healthCost: 0, pointsAward: 0, action: .swap)
        
        let page1 = GrogPage(name: "The Bedroom", pageID: 1000, storyText: "You are in a dark room. There is a cat on a bed, a lamp on a nightstand, and a light switch on the wall here. Maybe touching one of these things will do something interesting?", commands: [cmd1, cmd2, cmd3, cmd5])
        let page2 = GrogPage(name: "Cat Scratch", pageID: 1001, storyText: "You reach out to pet the cat but it scraches your hand with its wicked sharp claws and runs out of the room. You might want to clean that wound when you get a chance.", commands: [cmd2, cmd3, cmd5])
        let page3 = GrogPage(name: "Pop Bang", pageID: 1002, storyText: "The lamp on the nightstand glows bightly, so brightly that it expodes in a shower of sparks and the room is plunged into total darkness.", commands: [cmd3, cmd5])
        let page4 = GrogPage(name: "Back to Bed", pageID: 1003, storyText: "You crawl into bed and pull the covers over your head. It's warm and comfy. So comfy that the cat curls up to sleep on your stomach.", commands: [cmd4, cmd5])
        
        let mainStorybook = GrogStorybook(name: "Main Story", storyID: 10, pages: [page1, page2, page3, page4], theme: theme1)
        
        
        // Help storybook
        let theme2 = GrogTheme(screenColor: UIColor.darkGray, textColor: UIColor.white)
        let cmd6 = GrogCommand(name: "Yes", commandID: r5c3, nextPageID: noPage, healthCost: 0, pointsAward: 0, action: .swap)
        let page5 = GrogPage(name: "Help", pageID: 2000, storyText: "Welcome to Grog 2500 my friend. It's super to meet you. Do you want to play a game?", commands: [cmd6])
        let helpStorybook = GrogStorybook(name: "Help Story", storyID: 20, pages: [page5], theme: theme2)
        
        return [mainStorybook, helpStorybook]
        
    }
    
    // system functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUI()
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
        
        switch cmd.action {
        case .clear:
            let nextPage = currentStory.pages.filter { $0.pageID == cmd.nextPageID }.first!
            
            // clear the output and go to the next page
            story.text = ""
            
            // restart the game and go to the next page
            game!.currentPageID = nextPage.pageID
            game = nil
            loadUI()
        case .jump:
            let nextPage = currentStory.pages.filter { $0.pageID == cmd.nextPageID }.first!
            
            // output the label
            let buttonLabel = (sender as! UIButton).titleLabel!.text!
            story.text = story.text + " \(buttonLabel) \n"
            
            // go to the next page
            game!.currentPageID = nextPage.pageID
            loadUI()
        case .swap: break
            // TODO: Ready to implement swap!!!
        }
    }
}

