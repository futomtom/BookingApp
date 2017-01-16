
import UIKit


class AddProductVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  let fireService = FireService.sharedInstance
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var durationField: UITextField!
  @IBOutlet weak var priceField: UITextField!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var oldPriceField: UITextField!

  var imagePath: URL?

  override func viewDidLoad() {
    super.viewDidLoad()
  }


  @IBAction func pictureFromFirebase(_ sender: Any) {
  }

  @IBAction func pictureFromLocal(_ sender: Any) {
    let alertController = UIAlertController(title: "選擇功能", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)

    let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
      (action) in

    }

    let photoLibrayTappedAction = UIAlertAction(title: "選取照片", style: .default) {
      (action) in
      AddProductVC.photoLibrayTapped(controller: self) {
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
      AddProductVC.cameraTapped(controller: self) {
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
      let productCount = fireService.totalOrders.count + 1
      let imageName = "product\(productCount).jpg"
      imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

      if let jpegData = UIImageJPEGRepresentation(image as! UIImage, 0.4) {
        try? jpegData.write(to: imagePath!)
      }

      //update cell image
      productImageView.image = image as? UIImage
    }
    dismiss(animated: true, completion: nil)
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }



  @IBAction func submitPressed(_ sender: Any) {
    guard nameField.hasText, durationField.hasText, priceField.hasText else {
      let alert = UIAlertController(title: "Error", message: "data empty.", preferredStyle: .alert)
      present(alert, animated: true, completion: nil)
      return
    }

    let productName = nameField.text!
    let time = Int(durationField.text!)
    let oldPrice = Int(priceField.text!)
    let price = Int(priceField.text!)
    let email = fireService.currentUser.email


    let product = Product(productName: productName, duration: time!, price: price!, oldPrice: oldPrice!, creator: email!, vaild: false, imageName: "product1")
    fireService.addProduct(product: product)
//for Proudct image
    fireService.uploadtoFirebase(Path: imagePath!)


    let _ = navigationController?.popViewController(animated: true)
  }

  func alert(title: String, message: String) {

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
      (action) in
    }
    alertController.addAction(cancel)

    present(alertController, animated: true, completion: nil)
  }



}
