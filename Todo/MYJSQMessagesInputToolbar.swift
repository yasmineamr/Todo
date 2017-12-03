import UIKit
import JSQMessagesViewController

class MYJSQMessagesInputToolbar: JSQMessagesInputToolbar {

    override func loadContentView() -> JSQMessagesToolbarContentView! {
        self.preferredDefaultHeight = 90.0
        
        let nib = Bundle.main.loadNibNamed(String(describing: MYJSQMessagesToolbarContentView.self), owner: self, options: nil)
        return nib?.first as? MYJSQMessagesToolbarContentView
    }
}
