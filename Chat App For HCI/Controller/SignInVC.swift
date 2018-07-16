//
//  SignInVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/23/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignInVC: UIViewController {
    private let SIGNTOSESSION_SEGUE = "SignToSessionSegue";
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if AuthProvider.Instance.isLoggedIn(){
//            performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
//        }
//    }

    @IBAction func login(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != ""{
            AuthProvider.Instance.login(withUsername: usernameField.text!, password: passwordField.text!, loginHandler: {(message) in
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                    self.performSegue(withIdentifier: self.SIGNTOSESSION_SEGUE, sender: nil);
                }
            })
        } else{
            alertTheUser(title: "Credentials Required", message: "Please enter valid email and/or password in the text field")
        }
        
    }
    @IBAction func signup(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != ""{
            AuthProvider.Instance.signUp(withUsername: usernameField.text!, password: passwordField.text!, loginHandler: {(message) in
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating New User", message: message!)
                } else {
                   self.performSegue(withIdentifier: self.SIGNTOSESSION_SEGUE, sender: nil);
                }
            })
        } else{
            alertTheUser(title: "Credentials Required", message: "Please enter a new email and password in the text field to sign up")
        }
    }
    

    
    private func alertTheUser(title: String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
}
