//
//  MYJSQMessagesToolbarContentView.swift
//  JQSMessageCustomInputBar
//
//  Created by zzxxx on 12/20/16.
//  Copyright © 2016 demo. All rights reserved.
//

import UIKit
import JSQMessagesViewController


var completeFlag = 0
var deleteFlag = 0

class MYJSQMessagesToolbarContentView: JSQMessagesToolbarContentView {


    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!


    @IBAction func viewTasks(_ sender: Any) {
        print("in view")
        let json = ["message": "view"]
        do {

            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let url = NSURL(string: "https://agile-forest-45689.herokuapp.com/chat")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"

            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(uuid, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil {
                    print("Error! -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]

                    let text = (result!["message"] as? String)!
                    print(text)
                    if let message = JSQMessage(senderId: "22", displayName: "Habiiba", text: text)
                    {
                        messages.append(message)
                    }

                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }

    }

    @IBAction func deleteTask(_ sender: Any) {
        print("in delete")
        completeFlag = 0
        deleteFlag = 1

        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: "Enter task number")
        {
            messages.append(message)

            ChatViewController().finishReceivingMessage()
        }
        ChatViewController().finishSendingMessage()
    }
    @IBAction func completeTask(_ sender: Any) {
        print("in complete")
        deleteFlag = 0
        completeFlag = 1
        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: "Enter task number")
        {
            messages.append(message)

            ChatViewController().finishReceivingMessage()
        }
    }

}
