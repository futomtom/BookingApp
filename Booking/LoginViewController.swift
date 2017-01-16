import UIKit
import BRYXBanner
import FBSDKLoginKit
import GoogleSignIn


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
  

  @IBOutlet weak var fb_loginButton: FBSDKLoginButton!
  @IBOutlet weak var signInButton: GIDSignInButton!
  // MARK: Outlets
  var userName: String = ""
  var userEmail: String = ""
  var userNickname: String = ""
  var storeID: String = "001"
  var currentUser:FIRUser?
 // static var prefetch:Bool  = false
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var storeIDField: UITextField!
  let appDelegate = UIApplication.shared.delegate as! AppDelegate


  override func viewDidLoad() {
    super.viewDidLoad()
    fb_loginButton.readPermissions = ["public_profile", "email", "user_friends"]
    fb_loginButton.delegate = self


    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
      if user != nil {
        self.currentUser = user
        self.appDelegate.processToMainPage()
      }
    }
    //google
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
 //   UserDefaults().set(storeID, forKey: "storeID")
    FirePath.setPath(storeID: storeID)
    

  }
  

  
  // MARK: Actions
  @IBAction func loginDidTapped(_ sender: AnyObject) {
    guard !((emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)!) else {
      return
    }

    let email = emailField.text!
    let password = passwordField.text!


    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
      if let error = error {
        self.showMessagePrompt(msg: error.localizedDescription)
        return
      }
      
      self.appDelegate.processToMainPage()

    }
  }

  func showMessagePrompt(msg: String) {
    let banner = Banner(title: msg, subtitle: "", image: nil, backgroundColor: .red)
    banner.dismissesOnTap = true
    banner.show(duration: 3.0)
  }


//FaceBook beging
  public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    if FBSDKAccessToken.current() != nil {
      let fbToken = FBSDKAccessToken.current().tokenString
      let fireCredential = FIRFacebookAuthProvider.credential(withAccessToken: fbToken!)
      signInWithCredential(credential: fireCredential)

    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    //must have 
  }
 //FaceBook end




  private func signInWithCredential(credential: FIRAuthCredential) {

    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
      guard error == nil else {
        return
      }

      let user = FIRAuth.auth()?.currentUser
      user?.link(with: credential)
      self.appDelegate.processToMainPage()
    })
  }


  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    let authentication = user.authentication
    let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
    signInWithCredential(credential: credential)
  }

}


extension LoginViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField {
      passwordField.becomeFirstResponder()
    }
    if textField == passwordField {
      textField.resignFirstResponder()
    }
    return true
  }

}
