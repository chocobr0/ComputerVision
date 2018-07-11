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
    private let SIGNTOCHAT_SEGUE = "SignToChatSegue";
    static var sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
    static var contSessionKey = "";
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
                    self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
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
                   self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
                }
            })
        } else{
            alertTheUser(title: "Credentials Required", message: "Please enter a new email and password in the text field to sign up")
        }
    }
    
    @IBAction func newSession(_ sender: Any) {
        SignInVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
    }
    
    @IBAction func contSession(_ sender: Any) {
        getSession();
        //SignInVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).child(SignInVC.contSessionKey); //this is bugging -> might be a simple issue as it is an appdelegate error
    }
    
    func getSession() {
        Database.database().reference().child(Constants.SESSIONS).queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.childAdded) {
            (snapshot: DataSnapshot) in
            SignInVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).child(snapshot.key);
            //SignInVC.contSessionKey = snapshot.key;
            print("KEY: ", snapshot.key);
            print("Saved Key: ", SignInVC.contSessionKey);
        }
    }
    
    private func alertTheUser(title: String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
}
