

import UIKit


class SignUpViewController: UIViewController {


  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var userNameField: UITextField!


  override func viewDidLoad() {
    super.viewDidLoad()


  } // viewDidLoad

  @IBAction func onSignUp(_ sender: Any) {
    guard !((userNameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! || (emailTextField.text?.isEmpty)!) else {
      return
    }

    //     let username = userNameField.text!
    let password = passwordField.text!
    let email = emailTextField.text!

    FIRAuth.auth()!.createUser(withEmail: email, password: password) { user, error in
      guard error != nil else {
        return
      }

      FIRAuth.auth()!.signIn(withEmail: email, password: password)
      if let _ = FIRAuth.auth()?.currentUser {
        //  let name = user.displayName
        //  print(name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.processToMainPage()
      }
    }
  }


@IBAction func Dismiss(_ sender: Any) {

  dismiss(animated: true)
}
}
