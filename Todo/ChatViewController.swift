import UIKit
import JSQMessagesViewController

var messages = [JSQMessage]()
class ChatViewController: JSQMessagesViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = uuid
        senderDisplayName = "Habiiba"
        
        self.inputToolbar.contentView.leftBarButtonItem = nil //hides the attachment button on the left of the chat text input field
        
        // set the avatar size to zero and hiding it
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        topContentAdditionalInset = 50
        self.addNavBar()
        
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
        
        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: welcome)
        {
            messages.append(message)
            
            self.finishReceivingMessage()
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    //hide avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    //is called when the label text is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    //is called when the height of the top label is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        if let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        {
            messages.append(message)
            
            self.finishReceivingMessage()
            finishSendingMessage()
            
            if completeFlag == 1{
                print("in complete flag")
                
                let json = ["message": "completed: "+text]
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let url = NSURL(string: "https://agile-forest-45689.herokuapp.com/chat")!
                    //                    let url = NSURL(string: "http://127.0.0.1:3000/chat")!
                    
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
                                self.finishReceivingMessage()
                            }
                            self.finishSendingMessage()
                            
                        } catch {
                            print("Error -> \(error)")
                        }
                    }
                    task.resume()
                } catch {
                    print(error)
                }
                completeFlag = 0
            }
            else if deleteFlag == 1{
                print("in delete flag")
                
                let json = ["message": "delete: "+text]
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let url = NSURL(string: "https://agile-forest-45689.herokuapp.com/chat")!
                    //                    let url = NSURL(string: "http://127.0.0.1:3000/chat")!
                    
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
                                self.finishReceivingMessage()
                            }
                            self.finishSendingMessage()
                            
                        } catch {
                            print("Error -> \(error)")
                        }
                    }
                    task.resume()
                } catch {
                    print(error)
                }
                deleteFlag = 0
            }
            else{
                completeFlag = 0
                deleteFlag = 0
                let json = ["message":text]
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let url = NSURL(string: "https://agile-forest-45689.herokuapp.com/chat")!
                    //                    let url = NSURL(string: "http://127.0.0.1:3000/chat")!
                    
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
                                self.finishReceivingMessage()
                            }
                            self.finishSendingMessage()
                            
                        } catch {
                            print("Error -> \(error)")
                        }
                    }
                    task.resume()
                } catch {
                    print(error)
                }
            }
        }
        // finishSendingMessage()
    }
    
    func receiveMessage(passMessage: String!) {
        print("!!!")
        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: passMessage)
        {
            messages.append(message)
            
            self.finishReceivingMessage()
        }
        finishSendingMessage()
    }
    
    func makeConversation() -> [JSQMessage] {
        // This is just for demo purposes, if you add more messages to this array they will appear in your conversation feed.
        return [JSQMessage(senderId: "053496-4509-288", displayName: "Dan leonard", text: "Check out this awesome library called JSQMessagesViewController")]
    }
    
    override class func nib() -> UINib! {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func addNavBar() {
        // https://stackoverflow.com/questions/39566793/navigation-bar-with-jsqmessages
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 667, height:54)) // Offset by 20 pixels vertically to take the status bar into account
        print(view.frame.size.width)
        
        //        [[UINavigationBar, appearance], setAutoresizingMask,:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
        
        
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = true;
        navigationBar.invalidateIntrinsicContentSize();
        
        // Create a navigation item with a title
//        let navigationItem = UINavigationItem()
//        navigationItem.title = ""
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Sign out", style:   .plain, target: self, action: #selector(btn_clicked(_:)))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        navigationBar.isTranslucent = false

        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func btn_clicked(_ sender: UIBarButtonItem) {
        //https://stackoverflow.com/questions/37936560/how-to-sign-out-of-google-after-being-authenticated
        // Do something
        signInFlag = 0
        messages = [JSQMessage]()
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "back", sender: self)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user:GIDGoogleUser!,
              withError error: Error!)
    {
        // Perform any operations when the user disconnects from app here.
    }
    
}
