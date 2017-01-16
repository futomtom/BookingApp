
import UIKit

protocol FootViewDelegate {
    func logout()
}

class FootView: UIView {
    var delegate: FootViewDelegate?

 
 
    @IBAction func logoutTapped(_ sender: Any) {
        delegate?.logout()

    }
}


