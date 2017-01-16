import UIKit
import SideMenu
import CustomizableActionSheet

class SettingViewController: UITableViewController {
  let setttingsLabel = ["", "Start time", "End Time", "address", "phone"]
  var actionSheet: CustomizableActionSheet?
  var openTime = "8:30"
  var closeTime = "17:30"
  var workDays: Array<Bool> = Array(repeating: false, count: 7)
  var settings: Settings!
  var address: String!
  var phone: String!

  let fireService = FireService.sharedInstance

  override func viewDidLoad() {

    tableView.tableFooterView = UIView()

    settings = fireService.getSettings()
    workDays = fireService.workDays
    openTime = settings.openTime
    closeTime = settings.closeTime
    address = settings.address
    phone = settings.phone

  }


  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return indexPath.row == 0 ? 100 : 50
  }


  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }

  // MARK: UITableView Delegate methods

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings == nil ? 0 : 5
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "workdayCell", for: indexPath) as! WorkdayCell
      // cell.delegate = self
      cell.setButtons(status: workDays)
      return cell
    case 1, 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelCell
      cell.titleLabel.text = setttingsLabel[indexPath.row]
      cell.valueLabel.text = indexPath.row == 1 ? openTime : closeTime
      return cell

    case 3, 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: "textfiledCell", for: indexPath) as! TextFieldCell
      cell.titleLabel.text = setttingsLabel[indexPath.row]
      cell.textField.keyboardType = indexPath.row == 3 ? .default:.phonePad
      cell.result = indexPath.row == 3 ? settings.address : settings.phone
      cell.textField.text = cell.result
      return cell
    default:
       return UITableViewCell()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    print("TODO: save setting to server")
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      tableView.deselectRow(at: indexPath, animated: false)
    case 1, 2:
      showDatePicker(index: indexPath.row)
    default:
      break
    }
  }

  func showDatePicker(index: Int) {

    var items = [CustomizableActionSheetItem]()

    let pickerItem = CustomizableActionSheetItem()
    pickerItem.type = .view
    pickerItem.height = 200

    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .time
    pickerItem.view = datePicker
    datePicker.backgroundColor = .white


    let now = Date()
    let hour = index == 1 ? openTime.getHour() : closeTime.getHour()
    let date = Date(year: now.year, month: now.month, day: now.day, hour: hour, minute: 0, second: 0)

    datePicker.setDate(date, animated: false)
    items.append(pickerItem)

    let actionSheet = CustomizableActionSheet()
    self.actionSheet = actionSheet
    actionSheet.showInView(self.tableView, items: items) {
      let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! LabelCell

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      if index == 1 {
        self.openTime = dateFormatter.string(from: datePicker.date)
        cell.valueLabel.text = self.openTime
      } else {
        self.closeTime = dateFormatter.string(from: datePicker.date)
        cell.valueLabel.text = self.closeTime
      }


    }
  }
  @IBAction func selectWorkDay(_ button: UIButton) {
    button.isSelected = !button.isSelected
    workDays[button.tag] = button.isSelected
  }



  @IBAction func DoneTapped(_ sender: Any) {
    var workDaysString = ""
    for i in 0 ..< workDays.count {
      if workDays[i] {
        workDaysString += "\(i),"
      }
    }
    var cell = tableView.cellForRow(at: IndexPath(row: 3  , section: 0)) as! TextFieldCell
    cell.textField.endEditing(true)
    address = cell.result
     cell = tableView.cellForRow(at: IndexPath(row: 4  , section: 0)) as! TextFieldCell
    cell.textField.endEditing(true)
    phone = cell.result

    let setting = Settings(workDays: workDaysString, openTime: openTime, closeTime: closeTime, address: address, phone: phone)
    fireService.UpdateSetting(settings: setting)

  }


}


