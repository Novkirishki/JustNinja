//
//  ComposeHighscoreViewController.swift
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/4/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

import Parse

class ComposeHighscoreViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var usernameField: UITextField! = UITextField()
    @IBOutlet weak var scoreLabel: UILabel! = UILabel()
    @IBOutlet weak var image: UIImageView!
    
    var score: String!
    var tempImage: UIImage!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        
        if score == "0" {
            performSegueWithIdentifier("segueToHS", sender: nil)
        }
        
        super.viewDidLoad()
        
        scoreLabel.text = score
        usernameField.becomeFirstResponder()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location!.coordinate
    }
    
    @IBAction func captureImage() {
        let imageFromSourse = UIImagePickerController()
        imageFromSourse.delegate = self
        imageFromSourse.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imageFromSourse.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imageFromSourse.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imageFromSourse, animated: true, completion: nil)
    }
    
    @IBAction func saveHighscore(sender: AnyObject) {
        let highscore = PFObject(className:"Highscore")
        let scoreAsNumber = Int(score)
        highscore["Score"] = NSNumber(integer: scoreAsNumber!)
        highscore["Username"] = usernameField.text
        
        if tempImage != nil {
            let imageData = UIImagePNGRepresentation(tempImage)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            highscore["Image"] = imageFile
        }
        
        let point = PFGeoPoint(latitude:location.latitude, longitude:location.longitude)
        highscore["Location"] = point
        
        highscore.saveInBackground()
        performSegueWithIdentifier("segueToHS", sender: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
