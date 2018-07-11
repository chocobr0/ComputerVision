//
//  ChatVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/26/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase

class ChatVC: JSQMessagesViewController, MessageReceivedDelegate, UINavigationControllerDelegate{
    
    private var messages = [JSQMessage]();
    private var newMessageRefHandle: MessagesHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessagesHandler.Instance.delegate = self;
        self.senderId = AuthProvider.Instance.userID();
        self.senderDisplayName = AuthProvider.Instance.userName;
        MessagesHandler.Instance.observeMessages();
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        print("ACCESSING CHATVC");
    }
    
    //COLLECTION VIEW FUNCTIONS

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = messages[indexPath.item];
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray);
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item];
        if message.senderId == "lqizrjTo60Q3vTZlo16W0wldNA63" {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "determinedTesterMS"), diameter: 30);
        } else {
            if message.text == "Hello" {
                return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "smileMS"), diameter: 30);
            }
            else if message.text == "Great" {
                return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "disappointMS"), diameter: 30);
            }
            else {
                return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "normalMS"), diameter: 30);
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    
    //END COLLECTION VIEW FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text);
        self.finishSendingMessage();
    }
    
    //DELEGATION FUNCTIONS
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        print(messages.count)
        collectionView.reloadData();
    }
    
    //END DELEGATION FUNCTIONS
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            navigationController?.popViewController(animated: true);
            self.dismiss(animated: true, completion: nil);
            print("LOGGGGED OUT");
        }
    }
    
    var seconds = 120;
    var timer = Timer();
    var reset = false;
    @IBOutlet weak var countdown: UIButton!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var timingChat: UINavigationItem!
    @IBAction func count(_ sender: Any) {
        if(reset == false){
            //dismiss(animated: true, completion: nil);
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatVC.counter), userInfo: nil, repeats: true);
            reset = true;
        }
        else{
            timer.invalidate();
            timingChat.prompt = "-click again to restart-";
            seconds = 120
            reset = false;
        }
    }
    @objc func counter(){
        seconds -= 1;
        timingChat.prompt = String(seconds) + " Seconds";
        if (seconds == 0){
            timer.invalidate();
        }
    }
    
    //should stop observing when ChatVC isn't displaying but it aint! :(
    deinit {
        DBProvider.Instance.dbRef.removeAllObservers();
    }
    
} //class
