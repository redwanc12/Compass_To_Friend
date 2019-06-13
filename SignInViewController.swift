//
//  SignInViewController.swift
//  Instagram
//
//  Created by Redwan Chowdhury on 1/7/19.
//  Copyright © 2019 Redwan Chowdhury. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {
    
    //setting up variables and outlets
    @IBOutlet weak var usernameTB: UITextField!
    @IBOutlet weak var passwordTB: UITextField!
    @IBOutlet weak var warningL: UILabel!
    @IBOutlet weak var signInBOUT: UIButton!
    @IBOutlet weak var signUpBOUT: UIButton!
    @IBOutlet weak var titleL: UILabel!
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //setting design constraints
        warningL.numberOfLines = 3
        warningL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/2, left: screenWidth/10, bottom: screenHeight/15, right: screenWidth/10))
        
        let TFLength = screenHeight/11
        let usernameTop = screenHeight/3
        let passwordTop = screenHeight/2.4
        usernameTB.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: usernameTop, left:screenWidth/10, bottom: screenHeight-(usernameTop+TFLength), right: screenWidth/10))
        
        passwordTB.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: passwordTop, left:screenWidth/10, bottom: screenHeight-(passwordTop+TFLength), right: screenWidth/10))
        
        

        signInBOUT.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/2, left: screenWidth/10, bottom: screenHeight/2.4, right: screenWidth/1.7))
        

        signUpBOUT.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/2, left:screenWidth/1.7, bottom: screenHeight/2.4, right: screenWidth/10))
        
        titleL.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: screenHeight/15, left: screenWidth/10, bottom: screenHeight/2, right: screenWidth/10))
        
        
    }
    
    //sign in button
    @IBAction func signInB(_ sender: Any) {
        
        //chekcs if account exist
        var AccountFound = false
        let information = PFQuery(className: "signInfo")
        information.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil{
                for each in objects! {
                    let currentUsername: String = each["username"] as! String
                    let currentPassword: String = each["password"] as! String
                    //if account is a match
                    if((self.usernameTB.text == currentUsername) && (self.passwordTB.text == currentPassword)){
                        
                        self.warningL.text = ("Account found! Hello \(currentUsername)")
                        AccountFound = true
                        
                        //switches views to mapView
                        self.performSegue(withIdentifier: "plzWork", sender: self)
                                
                        break;
                    }
                }
                //if account does not exist
                if(!AccountFound){
                    self.warningL.text = ("Account dont exist")
                }
                
            }
        }
    }
    
    //function that makes the username pass when segue  called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "plzWork"){
            let displayVC = segue.destination as! MapViewController
            displayVC.username = usernameTB.text!
        }
    }
    
    //sign up button
    @IBAction func signUpB(_ sender: Any) {
        
        //checks if username is taken
        var accExistsAlready = false
        let information = PFQuery(className: "signInfo")
        information.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil{
                for each in objects! {
                    let currentUsername: String = each["username"] as! String
                    if(self.usernameTB.text! == currentUsername){
                        accExistsAlready = true
                        self.warningL.text = "taken"
                        break;
                    }
                }
                //if account exists, gives warning
                if(accExistsAlready){
                    self.warningL.text = "Username already taken."
                }
                else{
                    //creates it
                    let table = PFObject(className: "signInfo")
                    table["username"] = self.usernameTB.text
                    table["password"] = self.passwordTB.text
                    table.saveInBackground { (success: Bool, error: Error?) in
                        if(success){
                            self.warningL.text = "Account created. Log in now"
                        }
                        else{
                            self.warningL.text = "Error: Account did not create."
                        }
                    }
                    
                }
            }
        }
    
        
    }
    
    
}

//to programatically set layout areas
extension UIView{
    func anchor(top: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, trailing: NSLayoutXAxisAnchor, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
}

//to make keyboard dissapear when not used. Called in viewDidLoad
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
