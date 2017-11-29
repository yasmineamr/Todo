import UIKit
import JSQMessagesViewController


class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()

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
        senderId = "1234"
        senderDisplayName = "Yasmine"
        
        self.inputToolbar.contentView.leftBarButtonItem = nil //hides the attachment button on the left of the chat text input field
        
        // set the avatar size to zero and hiding it
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Do any additional setup after loading the view.
        
        if let message = JSQMessage(senderId: "1", displayName: "Todo", text: welcome)
        {
            self.messages.append(message)
            
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
            self.messages.append(message)
            
            self.finishReceivingMessage()
        }
        finishSendingMessage()
    }
    
    override class func nib() -> UINib! {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("In ChatViewController")
//        print(welcome)
//        welcomeMessage.text = welcome
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //MARK: Actions
//
//    @IBAction func viewTasks(_ sender: Any) {
//        welcomeMessage.text = "Todo is typing..."
//
//        let json = ["message": "view"]
//        do {
//
//            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//            let url = NSURL(string: "http://127.0.0.1:3000/chat")!
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "POST"
//
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            request.setValue(uuid, forHTTPHeaderField: "Authorization")
//            request.httpBody = jsonData
//
//            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//                if error != nil {
//                    print("Error! -> \(String(describing: error))")
//                    return
//                }
//                DispatchQueue.main.async(){
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
//                    print("Result -> \(String(describing: result))")
//                     self.welcomeMessage.text  = (result!["message"] as? String)!
//                } catch {
//                    print("Error -> \(error)")
//                }
//            }
//            }
//            task.resume()
//        } catch {
//            print(error)
//        }
//
//    }
    
}




