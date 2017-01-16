

import Foundation
import SideMenu


struct menuItem {
    var name: String
    var iconName: String
    var sequeID: String
}

class LeftMenuTableVC: UITableViewController {
    let menuItems = [menuItem(name: "OrderList", iconName: "dayview", sequeID: "orderlist"),
                     menuItem(name: "Booking", iconName: "Planner", sequeID: "dayorder"),
                     menuItem(name: "Product", iconName: "Massage_icon", sequeID: "productlist"),
                     menuItem(name: "Setting", iconName: "iconsetting", sequeID: "setting"),
                     menuItem(name: "Profile", iconName: "User", sequeID: "profile"),
                     menuItem(name: "Schedule", iconName: "User", sequeID: "segmentstatus"),
                     menuItem(name: "Income", iconName: "User", sequeID: "income")
                     //      menuItem(name: "周訂購狀態",iconName: "User",sequeID:"weeksegue")

    ]  //訂單列表  服務列表  設定  訂購狀態

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell

        cell.displayItem(item: menuItems[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*
          let vc = storyboard?.instantiateViewController(withIdentifier: menuItems[indexPath.row].vcID)
          SideMenuManager.menuLeftNavigationController?.pushViewController(vc!, animated: true)
       */
        performSegue(withIdentifier: menuItems[indexPath.row].sequeID, sender: nil)


    }


}
