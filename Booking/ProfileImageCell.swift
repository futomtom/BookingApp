

import UIKit

extension UIImageView {
    func circleImage() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.5
        // clipsToBounds = true
    }
}


protocol ProfileImageCellDelegate {

//    func didPressedEditButtonOnCell(_ cell: ProfileImageCell)
//    func didTappedBackgroundOnCell(_ cell: ProfileImageCell)
    func didTappedImageViewOnCell(_ cell: ProfileImageCell)
}

class ProfileImageCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var imageURL: URL! {
        didSet {
            fetchImagebyURL(url: imageURL) {
                image in
                self.profileImageView.image = image
            }

        }
    }
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.circleImage()
        }
    }


    //MARK: Public variables
    var delegate: ProfileImageCellDelegate?

    var cellHeight: CGFloat = 0
    var imageViewOriginalFrame: CGRect = CGRect.zero
    var imageViewTransformedFrame: CGRect = CGRect.zero


    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = false
        doInitialConfigurations()
    }

    //MARK: Public Methods
    func configureCellWithDetails() {
    }

    //MARK: Private Methods
    func doInitialConfigurations() {

        self.layoutIfNeeded()
        cellHeight = self.contentView.frame.size.height



        let tapGestureOnImageView = UITapGestureRecognizer(target: self, action: #selector(ProfileImageCell.tappedOnUserProfileImageView))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureOnImageView)
    }

    func fetchImagebyURL(url: URL, completion: @escaping (_

        image:UIImage?) -> ()) {
    //get image from from URL

    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        if error == nil {
            guard let data = data else {
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
task.resume()
}


func tappedOnUserProfileImageView() {
    self.delegate?.didTappedImageViewOnCell(self)
}


}
