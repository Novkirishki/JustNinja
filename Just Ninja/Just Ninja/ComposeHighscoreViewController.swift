//
//  ComposeHighscoreViewController.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/4/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Parse

class ComposeHighscoreViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField! = UITextField()
    @IBOutlet weak var scoreLabel: UILabel! = UILabel()
    
    var score: String!
    
    override func viewDidLoad() {
        
        if score == "0" {
            performSegueWithIdentifier("segueToHS", sender: nil)
        }
        
        super.viewDidLoad()
        
        scoreLabel.text = score
        usernameField.becomeFirstResponder()
    }
    
    @IBAction func saveHighscore(sender: AnyObject) {
        let highscore = PFObject(className:"Highscore")
 //       let scoreAsText = scoreLabel.text
//        let scoreAsNumber = Int(scoreAsText!)
//        highscore["Score"] = NSNumber(scoreAsNumber)
        highscore["Username"] = usernameField.text
        highscore.saveInBackground()
        
        let highscoresViewController = HighscoresTableViewController()
        self.presentViewController(highscoresViewController, animated: true, completion: nil)
    }
}
