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
    
    // UI functions
    
    func initUI() {
        score.text = "🎼 0"
        health.text = "💚 100%"
        time.text = "⏳ 00:00:00"
        status.text = "🎮 not started"
        location.text = "🗺 nowhere yet"
        story.text = ""
    }
    
    // system functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button functions
    
    @IBAction func inButton(_ sender: Any) {
    }
    
    @IBAction func outButton(_ sender: Any) {
    }

    @IBAction func upButton(_ sender: Any) {
    }
    
    @IBAction func downButton(_ sender: Any) {
    }
    
    @IBAction func northButton(_ sender: Any) {
    }
    
    @IBAction func westButton(_ sender: Any) {
    }
    
    @IBAction func eastButton(_ sender: Any) {
    }
    
    @IBAction func southButton(_ sender: Any) {
    }
    
    
}

