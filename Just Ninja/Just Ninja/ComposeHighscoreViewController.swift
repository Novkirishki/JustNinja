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
    var country: String!
    
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
        self.getPlaceName(manager.location!) { (answer) -> Void in
            self.country = answer
        }
    }
    
    func getPlaceName(location: CLLocation, completion: (answer: String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with an error" + error!.localizedDescription)
                completion(answer: "")
            } else if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                completion(answer: self.displayLocationInfo(pm))
            } else {
                print("Problems with the data received from geocoder.")
                completion(answer: "")
            }
        })
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) -> String
    {
        if let containsPlacemark = placemark
        {
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            return country!
        } else {
            return ""
        }
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
        
        if country != nil {
            highscore["Country"] = country
        }
        
        if tempImage != nil {
            let imageData = UIImagePNGRepresentation(tempImage)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            highscore["Image"] = imageFile
        }
        
        
        highscore.saveInBackground()
        performSegueWithIdentifier("segueToHS", sender: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
