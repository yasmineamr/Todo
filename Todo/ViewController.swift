import UIKit

var uuid: String = ""
var welcome: String = ""

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            // /welcome
            _ = UIViewController.displaySpinner(onView: self.view)
            let url = NSURL(string: "https://agile-forest-45689.herokuapp.com/welcome")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            let welcometask = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil {
                    print("Error! -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    uuid = (result!["uuid"] as? String)!
                    
                    // /chat token:
                    let token = (user.authentication.accessToken)!
                    let refreshtoken = (user.authentication.refreshToken)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXX"
                    let dateString = dateFormatter.string(from: user.authentication.accessTokenExpirationDate)
                    let message = "token: \(token) \(refreshtoken) \(dateString)"

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
                                print("Result -> \(String(describing: result))")
                                welcome = (result!["message"] as? String)!
                                DispatchQueue.main.async(){
                                self.performSegue(withIdentifier: "segue", sender: self);
                                }
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
            welcometask.resume()
        }
        else
        {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!)
    {
        // Perform any operations when the user disconnects from app here.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}


