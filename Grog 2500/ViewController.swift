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
    var game = GrogGameEngine()
    
    // UI functions
    
    func initUI() {
        score.text = "🎼 \(game.score)"
        health.text = "💚 \(game.player.health)%"
        time.text = "🚶‍♀️\(game.moves)"
        status.text = "🎮 \(game.status)"
        location.text = "🗺 \(game.player.location)"
        story.text = game.storyText
    }
    
    // system functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for actionButton in actionButtonCollection {
            actionButton.setTitle("", for: .normal)
        }
        
        initUI()
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

