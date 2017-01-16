

import UIKit
import SideMenu
import AMScrollingNavbar



class OrderListVC: ScrollingNavigationTableVC {
  let fireService = FireService.sharedInstance

  var totalOrders: [OrdersOfDate] = []
  var user: User!



  override func viewDidLoad() {
    let fireService = FireService.sharedInstance
    super.viewDidLoad()
    setupSideMenu()

    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.tableFooterView = UIView()

     fireService.getTotalOrders(completionHandler: { totalOrders in
      self.totalOrders = totalOrders
      print(totalOrders.count)
      DispatchQueue.main.async {  self.tableView.reloadData() }
    })

    /*
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateOrders), name: NSNotification.Name(rawValue: "ordersUpdated"), object: nil)
 */
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(tableView, delay: 50.0)
    }
  }


  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    // present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
  }


  fileprivate func setupSideMenu() {
    // Define the menus
    let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
    menuLeftNavigationController?.leftSide = true
    SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
    let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
    menuRightNavigationController?.leftSide = false
    SideMenuManager.menuRightNavigationController = menuRightNavigationController


  }
}

extension OrderListVC {
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return totalOrders[section].date
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = .blue
    header.textLabel?.textAlignment = .center
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return totalOrders.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return totalOrders[section].orders.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderCell
    cell.displayOrder(order: totalOrders[indexPath.section].orders[indexPath.row])

    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
/*
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let order = totalOrders[indexPath.row]
      order.ref?.removeValue()
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! OrderCell
    var order = totalOrders[indexPath.row]
    cell.checkimageV.isHidden = order.shipped
    order.shipped = !order.shipped
    order.ref?.updateChildValues(["shipped": !order.shipped])
  }
*/

}
