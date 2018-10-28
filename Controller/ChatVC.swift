//
//  ChatVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/26/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import ARKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase

class ChatVC: JSQMessagesViewController, MessageReceivedDelegate, UINavigationControllerDelegate, ARSessionDelegate{
    var timer = Timer();
    var currentExpression = "normalMS";
    let testerId = "lqizrjTo60Q3vTZlo16W0wldNA63";
    private var messages = [JSQMessage]();
    private var newMessageRefHandle: MessagesHandler?
    let session = ARSession();
    var runSession = true;
    var timeMSGSent = "NA";
    var timeExpressionDetected = "NA";
    var timeResponseStarts = "NA";
    var expressionData = "NA";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderDisplayName = "";
        MessagesHandler.Instance.delegate = self;
        self.senderId = AuthProvider.Instance.userID();
        MessagesHandler.Instance.observeMessages();
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true);
        let config = ARFaceTrackingConfiguration();
        config.worldAlignment = .gravity;
        session.delegate = self;
        if(runSession){
            session.run(config, options: []);
        } else {
            session.pause();
        }
    }
    
    ///////////////////////////////////////////////////////////////SETTING UP ARSESSION//////////////////////////////////////////////
    var currentFaceAnchor: ARFaceAnchor?
    var currentFrame: ARFrame?
    var expressionsToUse: [Expression] = [SmileExpression(), FrownExpression()] //SurpriseExpression(), AngerExpression(), CheekPuffExpression()
    var currentExpressionShownAt: Date? = nil
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.currentFrame = frame
        DispatchQueue.main.async {
            self.processNewARFrame()
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        self.currentFaceAnchor = faceAnchor
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
    }
    
    func processNewARFrame() {
        // called each time ARKit updates our frame (aka we have new facial recognition data)
        if let faceAnchor = self.currentFaceAnchor {
            if runSession {
                if (SmileExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "smileMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = SmileExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else if (SurpriseExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "stunnedMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = SurpriseExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else if (FrownExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "sadMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = FrownExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else if (AngerExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "angryMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = AngerExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else if (DisgustExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "disgustMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = DisgustExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else {
                    currentExpression = "normalMS"
                }
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////ENDING UP ARSESSION//////////////////////////////////////////////
    
    @objc func tick() {
        DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium);
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
        if message.senderId == testerId {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "testerMS"), diameter: 30);
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: message.senderDisplayName), diameter: 30);
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
        timeMSGSent = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium);
        let addExpressionData = " " + expressionData;
        let info = senderId + " MSG Sent: " + timeMSGSent + ", Expression Detected: " + timeExpressionDetected + addExpressionData;
        MessagesHandler.Instance.sendMessage(senderID: info, senderName: currentExpression, text: text);
        self.finishSendingMessage();
    }
    
    //DELEGATION FUNCTIONS
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        let currentUser = String(senderID.prefix(28))
        messages.append(JSQMessage(senderId: currentUser, displayName: senderName, text: text));
        collectionView.reloadData();
        runSession = true;
//        if ( (messages.last?.senderId) == testerId ) {
//            runSession = true;
//        } else {
//            runSession = false;
//            currentExpression = "normalMS";
//        }
    }
    
    //END DELEGATION FUNCTIONS
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        DBProvider.Instance.messagesRef.removeAllObservers();
//        Database.database().reference().child(Constants.SESSIONS).queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.childAdded) {
//            (snapshot: DataSnapshot) in
//            SessionVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).child(snapshot.key);
//        }
    }
    
    
    var seconds = 120;
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
    
    deinit {
        DBProvider.Instance.messagesRef.removeAllObservers();
    }
    
} //class
