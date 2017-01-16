import UIKit
import SideMenu
import FirebaseMessaging


class BookingConfirmViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var serviceLabel: UILabel!
//  weak var delegate: BookingConfirmViewControllerDelegate?
    var username: String = ""
    var checklistToEdit: Checklist?
    var ServiceName = "ServiceName"
    var selectItems: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = username

        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        // Do any additional setup after loading the view.
    }

    @IBAction func openMenu(_ sender: Any) {
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        if selectItems.count > 0 {
            serviceLabel.text = "user select \(selectItems.count) items"

        }
    }

    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = username
            checklist.ServiceName = ServiceName
            //   delegate?.bookingConfirmViewController(self,didFinishEditing: checklist)
        } else {

            let checklist = Checklist(name: textField.text!, ServiceName: ServiceName)
            //    delegate?.bookingConfirmViewController(self, didFinishAdding: checklist)
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buy" {
            let vc = segue.destination as! OrderingViewController
            vc.parentVC = self
        }
    }


}
