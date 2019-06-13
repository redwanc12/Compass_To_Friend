//
//  MapViewController.swift
//  Instagram
//
//  Created by Redwan Chowdhury on 2/2/19.
//  Copyright © 2019 Redwan Chowdhury. All rights reserved.
//

import UIKit
import Parse
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    //attributes for each user
    var username = "fail";
    var lat = 0.0;
    var long = 0.0;
    
    var partnerLat = 0.0
    var partnerLong = 0.0
    
    var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var partnerLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    //declarations
    @IBOutlet weak var userNameSL: UILabel!
    @IBOutlet weak var allowReqSL: UILabel!
    @IBOutlet weak var sendReqSL: UILabel!
    @IBOutlet weak var statusSL: UILabel!
    @IBOutlet weak var usernameL: UILabel!
    @IBOutlet weak var allowSwitch: UISwitch!
    @IBOutlet weak var sendReqB: UIButton!
    @IBOutlet weak var statusL: UILabel!
    @IBOutlet weak var sendReqTB: UITextField!
    @IBOutlet weak var pointer: UIImageView!
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        usernameL.text = username
        
        //constraints and layout
        let SLLength = screenHeight/14
        let userNameSLTop = screenHeight/2
        userNameSL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: userNameSLTop, left:screenWidth/15, bottom: screenHeight-(userNameSLTop+SLLength), right: screenWidth/4))
        
        let allowReqSLTop = userNameSLTop + (SLLength*1.5)
        allowReqSL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: allowReqSLTop, left:screenWidth/15, bottom: screenHeight-(allowReqSLTop+SLLength), right: screenWidth/4))
        
        let sendReqSLTop = allowReqSLTop + (SLLength*1.5)
        sendReqSL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: sendReqSLTop, left:screenWidth/15, bottom: screenHeight-(sendReqSLTop+SLLength), right: screenWidth/4))
        
        let statusSLTop = sendReqSLTop + (SLLength*1.5)
        statusSL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: statusSLTop, left:screenWidth/15, bottom: screenHeight-(statusSLTop+SLLength), right: screenWidth/4))
        
        usernameL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: userNameSLTop, left:screenWidth/1.2, bottom: screenHeight-(userNameSLTop+SLLength), right: screenWidth/15))
        
        allowSwitch.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: allowReqSLTop, left:screenWidth/1.2, bottom: screenHeight-(allowReqSLTop+SLLength), right: screenWidth/15))
        
        sendReqB.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: sendReqSLTop, left:screenWidth/1.2, bottom: screenHeight-(sendReqSLTop+SLLength), right: screenWidth/15))
        
        sendReqTB.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: sendReqSLTop, left:screenWidth/2.2, bottom: screenHeight-(sendReqSLTop+SLLength), right: screenWidth/9))
        
        statusL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/1.2, left:screenWidth/3, bottom: screenHeight/10, right: screenWidth/5))
        
        pointer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/17, left: screenWidth/3, bottom: screenHeight/1.5, right: screenWidth/3))
        
        
        //location manager requests
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
    }
    
    //location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            lat = currentLocation.coordinate.latitude
            long = currentLocation.coordinate.longitude
            location = CLLocation(latitude: lat, longitude: long)
        }
    }
    
    
    //compass manager
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if(partnerLat != 0.0){
            let converter = 0.0174533
            let bearing = getBearingBetweenTwoPoints1(point1: location, point2: partnerLocation)
            rotate(view: pointer, degrees: CGFloat(-newHeading.magneticHeading*converter + bearing))
        }
        
        
        
    }
    
    
    //button to send request
    @IBAction func sendButton(_ sender: Any) {
        //creates request
        let table = PFObject(className: "sendReq")
        table["from"] = username
        table["to"] = sendReqTB.text
        table["fromLAT"] = lat
        table["fromLONG"] = long
        
        table.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                self.statusL.textColor = UIColor.black
                self.statusL.text = "sent 😂"
            }
            else{
                self.statusL.text = "error"
            }
        }
        
    }
    
    //toggle on
    @IBAction func requestToggle(_ sender: Any) {
        
        if(allowSwitch.isOn){
            //checks if request exist
            let information = PFQuery(className: "sendReq")
            information.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if error == nil{
                    for each in objects! {
                        let from: String = each["from"] as! String
                        let to: String = each["to"] as! String
                        
                        //if account 'request to' exists
                        if(self.username == to){
                            
                            //gives pop up alert
                            let alert = UIAlertController(title: "New request", message: "\(from) wants to connect.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Connect", style: .default) { (action:UIAlertAction!) in
                                
                                //if user accepts to connect
                                self.statusL.text = "connected"
                                self.statusL.textColor = UIColor.green;
                                

                                //sets partenrs location
                                self.partnerLat = each["fromLAT"] as! Double
                                self.partnerLocation = CLLocation(latitude: each["fromLAT"] as! CLLocationDegrees, longitude: each["fromLONG"] as! CLLocationDegrees)
                                
                                //deletes the request
                                each.deleteInBackground(){ (Success: Bool, error: Error?) in
                                    
                                }
                                
                                
                            })
                            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                            
                            
                            
                            
                            break;
                        }
                    }
                    
                }
            }
            
        }
    }
    //function to rotate the imageview pointer
    func rotate(view: UIImageView, degrees: CGFloat){
        
        UIView.animate(withDuration: 0.1) {
            //degrees need to be in radians
            view.transform = CGAffineTransform(rotationAngle: degrees)
            //self.degreeRotated = self.degreeRotated+rotateConst
        }
    }
    
    //functions to calculaote bearing
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        //return radiansToDegrees(radians: radiansBearing)
        return radiansBearing
    }

    
}

