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
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!

    @IBOutlet weak var cvc: ChatViewController?

    func myCvc() -> ChatViewController {
        if cvc == nil {
            // https://stackoverflow.com/a/24590678
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? ChatViewController {
                    cvc = viewController
                    break
                }
            }
        }

        return cvc!
    }

    @IBAction func viewTasks(_ sender: Any) {
        print("in view")
        if let message = JSQMessage(senderId: uuid, displayName: "Habiiba", text: "View all tasks")
        {
            messages.append(message)

            myCvc().finishReceivingMessage()
        }
        myCvc().finishSendingMessage()

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
                    if let message = JSQMessage(senderId: "1", displayName: "Todo", text: text)
                    {
                        messages.append(message)
                        self.myCvc().finishReceivingMessage()
                        print("in view again")
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

        if let message = JSQMessage(senderId: uuid, displayName: "Habiiba", text: "Delete task")
        {
            messages.append(message)

            myCvc().finishReceivingMessage()
        }
        myCvc().finishSendingMessage()

        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: "Enter task number")
        {
            messages.append(message)

            myCvc().finishReceivingMessage()
        }
        myCvc().finishSendingMessage()
    }
    @IBAction func completeTask(_ sender: Any) {
        print("in complete")
        deleteFlag = 0
        completeFlag = 1
        if let message = JSQMessage(senderId: uuid, displayName: "Habiiba", text: "Complete task")
        {
            messages.append(message)

            myCvc().finishReceivingMessage()
        }
        myCvc().finishSendingMessage()

        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: "Enter task number")
        {
            messages.append(message)

            myCvc().finishReceivingMessage()
        }
    }

    @IBAction func createTask(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create Task", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Notes"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "dd/mm/yyyy"
        }


        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in


            let message = "create: title: \((alert?.textFields![0].text)!) notes: \((alert?.textFields![1].text)!) due: \((alert?.textFields![2].text)!) "

            let taskm = "Title: \((alert?.textFields![0].text)!) \n Notes: \((alert?.textFields![1].text)!) \n Due date: \((alert?.textFields![2].text)!) "

            if let task = JSQMessage(senderId: uuid, displayName: "Habiiba", text: taskm)
            {
                messages.append(task)

                self.myCvc().finishReceivingMessage()
            }
            self.myCvc().finishSendingMessage()


            let json = ["message": message]
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
                        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: text)
                        {
                            messages.append(message)
                            self.myCvc().finishReceivingMessage()
                        }

                    } catch {
                        print("Error -> \(error)")
                    }
                }
                task.resume()
            } catch {
                print(error)
            }


        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in

        }))

        // 4. Present the alert.
        myCvc().present(alert, animated: true, completion: nil)
    }


    @IBAction func updateTask(_ sender: Any) {
        let alert = UIAlertController(title: "Update Task", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Task number"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Notes"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "dd/mm/yyyy"
        }


        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in

            var message = "update: \((alert?.textFields![0].text)!)"

            if (alert?.textFields![1].text)!.characters.count > 0 {
                message = "\(message) title: \((alert?.textFields![1].text)!)"

            }

            if (alert?.textFields![2].text)!.characters.count > 0 {
                message = "\(message) notes: \((alert?.textFields![2].text)!)"

            }

            if (alert?.textFields![3].text)!.characters.count > 0 {
                message = "\(message) due: \((alert?.textFields![3].text)!)"
            }

            print(message)



            var taskm = "Update task number: \((alert?.textFields![0].text)!)"

            if (alert?.textFields![1].text)!.characters.count > 0 {
                taskm = "\(taskm) Title: \((alert?.textFields![1].text)!)"

            }

            if (alert?.textFields![2].text)!.characters.count > 0 {
                taskm = "\(taskm) Notes: \((alert?.textFields![2].text)!)"

            }

            if (alert?.textFields![3].text)!.characters.count > 0 {
                taskm = "\(taskm) Due: \((alert?.textFields![3].text)!)"
            }

            if let task = JSQMessage(senderId: uuid, displayName: "Habiiba", text: taskm)
            {
                messages.append(task)

                self.myCvc().finishReceivingMessage()
            }
            self.myCvc().finishSendingMessage()


            let json = ["message": message]
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
                        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: text)
                        {
                            messages.append(message)
                            self.myCvc().finishReceivingMessage()
                        }

                    } catch {
                        print("Error -> \(error)")
                    }
                }
                task.resume()
            } catch {
                print(error)
            }


        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in

       }))

        // 4. Present the alert.
        myCvc().present(alert, animated: true, completion: nil)


    }

}
