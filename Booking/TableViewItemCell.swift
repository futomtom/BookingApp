import UIKit

class TableViewItemCell: UICollectionViewCell {
  @IBOutlet weak var tableView: UITableView!
  let fireService = FireService.sharedInstance
  var openTime = 0
  var closeTime = 0
  var timeslot = 1
  var date: Date!
  var todayOrders: [Order]?

  func setData(begin: Int, end: Int, date: Date) {
    openTime = begin
    closeTime = end
    fireService.getOrdersByDate(date: date, completionHandler: { orders in
        self.todayOrders = orders
      DispatchQueue.main.async {  self.tableView.reloadData() }
    })
  }

}


extension TableViewItemCell: UITableViewDataSource {


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return closeTime - openTime + 1
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimeSlotTableViewCell
    let time = openTime + indexPath.row
    cell.begintime = time

    if let items = todayOrders?.filter({ $0.beginTime.getHour() == time }) {
      if items.count > 0 {
          cell.displayData(order: items[0])
      } else {
        cell.displayEmptyData()
      }
    }
    
    return cell
  }
}
