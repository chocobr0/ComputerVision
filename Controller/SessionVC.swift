//
//  SessionVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 7/10/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SessionVC: UIViewController {
    private let SIGNTOCHAT_SEGUE = "SignToChatSegue";
    static var sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func newSession(_ sender: Any) {
        SessionVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
        self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
    }
    
    @IBAction func contSession(_ sender: Any) {
        Database.database().reference().child(Constants.SESSIONS).queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.childAdded) {
            (snapshot: DataSnapshot) in
            if(snapshot.hasChildren()){
                SessionVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).child(snapshot.key);
                self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
            }
        }
    }
}
