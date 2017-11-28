//
//  ViewController.swift
//  Todo
//
//  Created by Yasmine Amr on 11/27/17.
//  Copyright © 2017 Yasmine Amr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let objObjectiveCFile = Todo()
        objObjectiveCFile.displayMessageFromCreatedObjectiveCFile()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "349558669094-s6k8ll3co24e64j0v7avdq961ejjm84s.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            let userId = user.userID // For client-side use only!
            let idToken = user.authentication.idToken //Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            let userImageURL = user.profile.imageURL(withDimension: 200)
            // ...
            print("---------------------------------")
            print(user.authentication.accessToken)
            print(user.authentication.idToken)
            print(user.authentication.accessTokenExpirationDate)
            //            print(user.authentication)
            //            dump(user)
            print("---------------------------------")
            
            // /welcome
            let url = NSURL(string: "http://127.0.0.1:3000/welcome")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            let task1 = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil {
                    print("Error! -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(result)")
                    self.uuid = (result!["uuid"] as? String)!
                    print(self.uuid)
                    
                    // /chat token:
                    let token = (user.authentication.accessToken as? String)!
                    let refreshtoken = (user.authentication.refreshToken as? String)!
//                    let date = (user.authentication.accessTokenExpirationDate as? String)!
                    
                    let myDate = "2016-06-20T13:01:46.457+02:00"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXX"
//                    let date = dateFormatter.dateFromString(myDate)!
//                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let dateString = dateFormatter.string(from: user.authentication.accessTokenExpirationDate)
                    print("DATE")
                    print(dateString)
                    var message = "token: \(token) \(refreshtoken) \(dateString)"

                    //       message += String(describing: token)
                    let json = ["message": message]
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let url = NSURL(string: "http://127.0.0.1:3000/chat")!
                        let request = NSMutableURLRequest(url: url as URL)
                        request.httpMethod = "POST"
                        
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.setValue(self.uuid, forHTTPHeaderField: "Authorization")
                        request.httpBody = jsonData
                        
                        
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                            if error != nil{
                                print("Error! -> \(error)")
                                return
                            }
                            do {
                                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                                print("Result -> \(result)")
                                
                            } catch {
                                print("Error -> \(error)")
                            }
                        }
                        
                        task.resume()
                    } catch {
                        print(error)
                    }


                } catch {
                    print("Error -> \(error)")
                }
            }

            task1.resume()
            
            

        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!)
    {
        // Perform any operations when the user disconnects from app here.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

