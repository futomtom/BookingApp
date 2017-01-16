import UIKit
import SideMenu
import BRYXBanner
import Timepiece



class PutOrderVC: UITableViewController, UIGestureRecognizerDelegate {
  let fireService = FireService.sharedInstance
  var totalProducts: [Product] = []
  var selectedIndexOfProducts: [Int] = []
  var parentVC: OrderListVC!
  var cartButton = MIBadgeButton()
  var panGesture: UIGestureRecognizer?
  var edgePanGestures: [UIGestureRecognizer]?
  var beginTime: Date!

  @IBOutlet weak var ShoppingCartBarItem: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 160
    tableView.sectionHeaderHeight = 44
    tableView.allowsMultipleSelectionDuringEditing = false
    totalProducts = fireService.totalProducts
    tableView.reloadData()

    let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    cartButton.frame = frame
    cartButton.badgeString = "0"
    cartButton.setImage(UIImage(named: "ShoppingCart"), for: .normal)

    ShoppingCartBarItem.customView = cartButton
  //  enableSwipeToMenu()
  }


/*
  fileprivate func enableSwipeToMenu() {
    panGesture = SideMenuManager.menuAddPanGestureToPresent(toView: navigationController!.navigationBar)
    edgePanGestures = SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: navigationController!.view)
  }
 
  override func viewWillDisappear(_ animated: Bool) {
    navigationController!.navigationBar.removeGestureRecognizer(panGesture!)
  }
*/

  @IBAction func SendResult(_ sender: Any) {
//    parentVC.selectItems = selectItems
    let _ = navigationController?.popViewController(animated: true)
  }

}
extension PutOrderVC {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return totalProducts.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
    cell.displayProduct(product: totalProducts[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = selectedIndexOfProducts.index(where: { $0 == indexPath.row })
    let cell = tableView.cellForRow(at: indexPath) as! ProductCell
    if index == nil {
      if checkTooMuchBooking() {
        return
      }

      selectedIndexOfProducts.append(indexPath.row)
      cell.checkimageV.isHidden = false
    } else {
      selectedIndexOfProducts.remove(at: index!)
      cell.checkimageV.isHidden = true
    }
    
    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    animation.duration = 1.0
    animation.values = [1.0,0.7,1.1,0.8,1.0]
    self.cartButton.layer.add(animation, forKey: "Scale")
    self.cartButton.badgeString = "\(self.selectedIndexOfProducts.count)"
    
  }

  func checkTooMuchBooking() -> Bool {
    if selectedIndexOfProducts.count >= 2 {
      let alertController = MIAlertController( title: "抱歉", message: "為公平起見,每人最多只能預定兩項,造成不便,敬請見諒 ")
      alertController.addButton(MIAlertController.Button(title: "OK"))
      alertController.presentOn(self)
      return true
    } else {
      return false
    }

  }
  
  @IBAction func performUnwindSegue(segue: UIStoryboardSegue) {
    // if segue.identifier == AnimalPickerViewController.UnwindSegue {
    //   label.text = (segue.sourceViewController as! AnimalPickerViewController).selectedAnimal
    navigationController?.popViewController(animated: false)
  
  }
  


  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "headercell")

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkOutTapped))
    tapRecognizer.delegate = self
    tapRecognizer.numberOfTapsRequired = 1
    tapRecognizer.numberOfTouchesRequired = 1
    headerCell?.addGestureRecognizer(tapRecognizer)
    return headerCell
  }

  func createOrder() -> Order {
    let user = fireService.currentUser
    let displayName = user.displayName ?? "anonymous"
    var products: [Product] = []
    for i in selectedIndexOfProducts {
      products.append(totalProducts[i])
    }
    var content = ""
    let _ = products.map( { content = content + $0.productName + " ," })
    content = String(content.characters.dropLast())
    
    var duration = 0
    let _ = products.map( { duration = duration + $0.duration })

    var totalPrice = 0
    let _ = products.map( { totalPrice = totalPrice + $0.price })
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let strBeginTime = dateFormatter.string(from: beginTime)
    let closeTime = beginTime + duration.minutes
    let strEndTime =  dateFormatter.string(from: closeTime!)
    dateFormatter.dateFormat = "dd-MM-yy"
    let date = dateFormatter.string(from: beginTime)

    let order = Order(orderID: "", userName: displayName, content: content, creator: user.email!, duration: duration, totalPrice: totalPrice, shipped: false, beginTime: strBeginTime, endTime: strEndTime, startDate: date, products: products)

    return order
  }


  func checkOutTapped(gestureRecognizer: UIGestureRecognizer)
  {
    if selectedIndexOfProducts.count == 0 { //cart empty
      displayBanner(title: "Info", subtitle: "Shopping cart is empty.")
      return
    }


    let vc = SideMenuManager.menuRightNavigationController?.viewControllers[0] as! RightMenuTableView
    vc.newOrder = createOrder()

    present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
  }

  func displayBanner(title: String, subtitle: String) {

    let banner = Banner(title: title, subtitle: subtitle, image: nil, backgroundColor: .orange)
    banner.dismissesOnTap = true
    banner.show(duration: 1.0)
  }
}
