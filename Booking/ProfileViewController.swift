let profileImageCellHeight: CGFloat = 200


import UIKit
import SideMenu
import MobileCoreServices
import FBSDKLoginKit


class ProfileViewController: UITableViewController, ProfileImageCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  let userData = FIRAuth.auth()?.currentUser?.providerData[0]
  let settings = ["Name", "Phone"]
  let fireService = FireService.sharedInstance


  override func viewDidLoad() {
    navigationItem.title = "Profile"


    //  let frontImage = UIImage (named: "Hospital")!.withRenderingMode (.alwaysTemplate)
    let FootView = UINib(nibName: "FootView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
    tableView.tableFooterView = FootView

  }

  func logout() {
    let firebaseAuth = FIRAuth.auth()
    do {
      try firebaseAuth?.signOut()
      //if facebook Login
      FBSDKAccessToken.setCurrent(nil)

    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.processToLoginPage()

    return
  }


  @IBAction func logoutTapped(_ sender: Any) {
    logout()

  }

  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }
  //MARK: Collection View DataSource & Delegate

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings.count + 1;
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
      cell.delegate = self
      if userData?.photoURL != nil {
        cell.imageURL = userData?.photoURL
      }

      cell.nameLabel.text = userData?.displayName
      return cell
    }

    switch indexPath.row {
    case 1, 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "textfiledCell", for: indexPath) as! TextFieldCell
      cell.titleLabel.text = settings[indexPath.row - 1]
      if indexPath.row == 1 {
        cell.textField.text = "alex"
      } else {
        cell.textField.text = "0936434982"
        cell.setKeyboardType(type: .numberPad)
      }
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! ButtonCell
      return cell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return indexPath.row == 0 ? 200 : 50
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      tableView.deselectRow(at: indexPath, animated: false)
    }
  }


  override func scrollViewDidScroll(_ scrollView: UIScrollView) {


    let indexPath = IndexPath(item: 0, section: 0)
    let cell = tableView?.cellForRow(at: indexPath) as? ProfileImageCell

    if cell != nil {

      if ((scrollView.contentOffset.y) > profileImageCellHeight) {

        //         navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Alex Fu"

      } else {
        navigationItem.title = "Profile"
        //           navigationController?.navigationBar.isHidden = true
      }
    }
  }

  func alert(title: String, message: String) {

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
      (action) in
    }
    alertController.addAction(cancel)

    present(alertController, animated: true, completion: nil)
  }


  func didTappedImageViewOnCell(_ cell: ProfileImageCell) {

    let alertController = UIAlertController(title: "選擇功能", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)

    let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
      (action) in

    }

    let photoLibrayTappedAction = UIAlertAction(title: "選取照片", style: .default) {
      (action) in
      ProfileViewController.photoLibrayTapped(controller: self) {
        (picker, isSourceTypeAvailable) in
        if isSourceTypeAvailable == true {
          self.present(picker!, animated: true, completion: nil)
        } else {
          self.alert(title: "請允讀取相簿", message: "")
        }
      }
    }

    let cameraTappedAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) {
      (action) in
      ProfileViewController.cameraTapped(controller: self) {
        (picker, isSourceTypeAvailable) in
        if isSourceTypeAvailable == true {
          self.present(picker!, animated: true, completion: nil)
        } else {
          self.alert(title: "請允許相機功能", message: "")
        }
      }
    }

    alertController.addAction(cancel)
    alertController.addAction(photoLibrayTappedAction)
    alertController.addAction(cameraTappedAction)


    present(alertController, animated: true, completion: nil)


  }


  static func cameraTapped<T>(controller: T, completionHandler: (UIImagePickerController?, _

                                                                 isSourceTypeAvailable: Bool) -> Void) where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {

    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let picker = UIImagePickerController()

      picker.delegate = controller
      picker.sourceType = .camera

      completionHandler(picker, true)
    } else {
      completionHandler(nil, false)
    }

  }

  static func photoLibrayTapped<T>(controller: T, completionHandler: (UIImagePickerController?, _

                                                                      isSourceTypeAvailable: Bool) -> Void) where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {

    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let picker = UIImagePickerController()

      picker.delegate = controller
      picker.sourceType = .photoLibrary

      completionHandler(picker, true)
    } else {
      completionHandler(nil, false)
    }
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] {
      let imageName = "headPhoto.jpg"
      let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

      if let jpegData = UIImageJPEGRepresentation(image as! UIImage, 0.4) {
        try? jpegData.write(to: imagePath)
      }
      fireService.uploadtoFirebase(Path: imagePath)
      //update cell image
      let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileImageCell
      cell.profileImageView?.image = image as? UIImage
    }
    dismiss(animated: true, completion: nil)
  }



  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }

}




