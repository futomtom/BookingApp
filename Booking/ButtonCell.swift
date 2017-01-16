

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var Button: UIButton! {
        didSet {
            Button.layer.borderColor = UIColor(red: 0.24, green: 0.49, blue: 0.84, alpha: 1.0).cgColor
            Button.layer.borderWidth = 1
            Button.layer.cornerRadius = 4
        }
    }


}

class ButtonNoBorderCell: UITableViewCell {
    @IBOutlet weak var Button: UIButton!
}
