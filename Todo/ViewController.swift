//
//  ViewController.swift
//  Todo
//
//  Created by Yasmine Amr on 11/27/17.
//  Copyright © 2017 Yasmine Amr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let objObjectiveCFile = Todo()
        objObjectiveCFile.displayMessageFromCreatedObjectiveCFile()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

