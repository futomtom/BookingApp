

import Foundation
import SideMenu
import Timepiece
import EventKit

class RightMenuTableView: UITableViewController, UIGestureRecognizerDelegate {
  let fireService = FireService.sharedInstance
  var newOrder: Order!
  var eventStore = EKEventStore()

  override func viewDidLoad() {
    tableView.rowHeight = 160
    tableView.sectionHeaderHeight = 60
    tableView.sectionFooterHeight = 44
  }

  /*
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
*/



  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let checkoutCell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! CheckOutCell

    checkoutCell.countLabel.text = "\(newOrder.products.count)"

    checkoutCell.priceLabel.text = "\(newOrder.totalPrice)"

    return checkoutCell

  }

 

  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "footercell")

    return headerCell
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "submited" {
      fireService.addOrder(order: newOrder!)
  /*
      AddToCalendar(order: newOrder!)
      let orderDescriptions = "You order:" + (newOrder?.beginTime)! + ". " + (newOrder?.content)!
      let alertController = MIAlertController( title: "Success!", message: orderDescriptions)
      alertController.addButton(MIAlertController.Button(title: "OK", type: .default, action: {
      })
      )
      alertController.presentOn(self)
 */
    }

  }
  

  func AddToCalendar(order: Order) {
    let time = newOrder.startDate + " " + newOrder.beginTime
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yy HH:mm"
 //   dateFormatter.locale = Locale(identifier: "zh_TW")
 //   dateFormatter.timeZone = TimeZone(secondsFromGMT: 60*60*8)

    let startDate = dateFormatter.date(from: time)!
  
   // let calendars = eventStore.calendars(for: .event)
    
    eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) -> Void in
      guard granted else {
        return
      }

      let event = EKEvent(eventStore: self.eventStore)
      //"2016/12/18 8:40".date(inFormat: "yyyy/MM/dd hh:mm")
      event.startDate = startDate
      event.title = "boookapp"
      event.endDate = (startDate + order.duration.minutes)!
      event.notes = order.content
      event.location = "somewhere"
      event.calendar = self.eventStore.defaultCalendarForNewEvents
      event.alarms = [EKAlarm.init(relativeOffset: -3600.0)]
      
      try! self.eventStore.save(event, span: .thisEvent)
    })
  }


  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return (newOrder?.products.count)!
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
      cell.displayProduct(product: (newOrder?.products[indexPath.row])!)
      return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
  }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

      return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
      } else if editingStyle == .insert {

      }
    }




  }
