//
//  GameViewController.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 1/31/16.
//  Copyright (c) 2016 Nikolai Novkirishki. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and confugure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.viewController = self
        
        // Present the scene
        skView.presentScene(scene)
    }
    
    override func loadView() {
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 667, height: 375 ))
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func openHighscores() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("navigation")
        self.presentViewController(nextViewController, animated:true, completion:nil)
//        let highscoresViewController:HighscoresTableViewController = HighscoresTableViewController()
//        
//        self.presentViewController(highscoresViewController, animated: true, completion: nil)
    }
}
	