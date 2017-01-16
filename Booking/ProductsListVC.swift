import UIKit
import SideMenu

class ProductsListVC: UITableViewController {
    let fireService = FireService.sharedInstance
    var totalProducts: [Product] = []



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 160
        fireService.getTotalProducts { (totalProducts) in
            self.totalProducts = totalProducts
            DispatchQueue.main.async {  self.tableView.reloadData() }
        }
    }



    @IBAction func openMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }


    // MARK: UITableView Delegate methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        cell.displayProduct(product: totalProducts[indexPath.row])
        

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = totalProducts[indexPath.row]
            product.ref?.removeValue()

            //items.remove(at: indexPath.row)
            //tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProductCell
        let product = totalProducts[indexPath.row]

        cell.checkimageV.isHidden = product.vaild // 這行你要check
        product.ref?.updateChildValues(["vaild": !product.vaild])
    }

}
