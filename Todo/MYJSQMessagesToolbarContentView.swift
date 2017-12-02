//
//  MYJSQMessagesToolbarContentView.swift
//  JQSMessageCustomInputBar
//
//  Created by zzxxx on 12/20/16.
//  Copyright © 2016 demo. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MYJSQMessagesToolbarContentView: JSQMessagesToolbarContentView {

    @IBOutlet weak var habiibaa: UIButton!
    
    @IBAction func habiibasAction(_ sender: Any) {
        print("Nourhaan")
//        didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
//        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: "welcome wala eh")
//        {
//            messages.append(message)
//
//            JSQMessagesViewController().finishReceivingMessage()
//        }
//        JSQMessagesViewController().finishSendingMessage()
        
        ChatViewController().receiveMessage(passMessage: "message.stringValue")
    }
    
}
