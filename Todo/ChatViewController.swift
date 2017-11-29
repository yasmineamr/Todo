import UIKit

class ChatViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var welcomeMessage: UILabel!
  @IBOutlet weak var viewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("In ChatViewController")
        print(welcome)
        welcomeMessage.text = welcome
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func viewTasks(_ sender: Any) {
        welcomeMessage.text = "Todo is typing..."

        let json = ["message": "view"]
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let url = NSURL(string: "http://127.0.0.1:3000/chat")!
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
                DispatchQueue.main.async(){
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(String(describing: result))")
                     self.welcomeMessage.text  = (result!["message"] as? String)!
                } catch {
                    print("Error -> \(error)")
                }
            }
            }
            task.resume()
        } catch {
            print(error)
        }
        
    }
    
}




