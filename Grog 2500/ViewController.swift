//
//  ViewController.swift
//  Grog 2500
//
//  Created by John Pavley on 4/4/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    var game:GrogGameEngine?
    
    // UI functions
    
    func initUI() {
        
        if let storybook = initStory() {
        
            let game = GrogGameEngine(storybook: storybook)
            
            game.player.location = game.storybook.pages[0].name
            
            score.text = "🎼 \(game.score)"
            health.text = "💚 \(game.player.health)%"
            time.text = "🚶‍♀️\(game.moves)"
            status.text = "🎮 \(game.status)"
            location.text = "🗺 \(game.player.location)"
            story.text = game.storybook.pages[0].storyText
            
            for actionButton in actionButtonCollection {
                actionButton.setTitle("", for: .normal)
            }
            
            let commandList = game.storybook.pages[0].commands
            
            for cmd in commandList {
                let btn = view.viewWithTag(cmd.commandID) as! UIButton
                btn.setTitle(cmd.name, for: .normal)
            }
        }
    }
    
    func initStory() -> GrogStorybook? {
        let cmd1 = GrogCommand(name: "Cat", commandID: 100, nextPageID: 1001, healthCost: -2, pointsAward: -1)
        let cmd2 = GrogCommand(name: "Switch", commandID: 105, nextPageID: 1002, healthCost: -2, pointsAward: -2)
        let cmd3 = GrogCommand(name: "Bed", commandID: 110, nextPageID: 1003, healthCost: 4, pointsAward: 4)
        let cmd4 = GrogCommand(name: "Restart", commandID: 112, nextPageID: 1000, healthCost: 0, pointsAward: 0)
        
        let page1 = GrogPage(name: "The Bedroom", pageID: 1000, storyText: "You are in a dark room. There is a cat on a bed, a lamp on a nightstand, and a light switch on the wall here. Maybe touching one of these things will do something interesting?", commands: [cmd1, cmd2, cmd3])
        
        let page2 = GrogPage(name: "Cat Scratch", pageID: 1001, storyText: "You reach out to pet the cat but it scraches you hand with its wicked sharp claws and runs out of the room.", commands: [cmd2, cmd3])
        
        let page3 = GrogPage(name: "Pop Bang", pageID: 1002, storyText: "The lamp on the nightstand glows bightly, so brightly that it expodes in a shower of sparks and the room is plunged into total darkness.", commands: [cmd3])
        
        let page4 = GrogPage(name: "Back to Bed", pageID: 1003, storyText: "You crawl into bed and pull the covers over your head. It's warm and comfy. So comfy that the cat curls up to sleep on your stomach.", commands: [cmd4])
        
        return GrogStorybook(name: "Test Story", storyID: 10, pages: [page1, page2, page3, page4])
        
    }
    
    // system functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
        initStory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button functions
    
    @IBAction func commandButton(_ sender: Any) {
        // let buttonID = (sender as AnyObject).tag!
        let buttonLabel = (sender as! UIButton).titleLabel!.text!
        
        story.text = story.text + " \(buttonLabel)"
    }
    
}

