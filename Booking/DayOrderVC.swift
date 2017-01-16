//
//  BookStatusVC.swift
//
//
//  Created by Alex on 11/7/16.
//
//

import UIKit
import SideMenu
import Timepiece

class DayOrderVC: UIViewController, WeekViewDelegate {

  @IBOutlet weak var weekView: WeekView!
  @IBOutlet weak var collectionView: UICollectionView!
  var settings: Settings!
  let fireService = FireService.sharedInstance

  var openTime = 7
  var closeTime = 17
  var workDays:[Bool]?
  var pickedDate = Date()
  var selectedIndex = 0

 


  override func viewDidLoad() {
    super.viewDidLoad()
    
    workDays = fireService.workDays
    openTime = fireService.openTimeHour!
    closeTime = fireService.closeTimeHour!
  
  
    let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.sectionHeadersPinToVisibleBounds = true //sticky head
    layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    weekView.delegate = self
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateOrders), name: NSNotification.Name(rawValue: "ordersUpdated"), object: nil)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    title = ""
  }
  
  
  override func viewWillAppear (_ animated: Bool) {
    title = NSLocalizedString(NSLocalizedString("Time Table",comment:""),comment:"")
     collectionView.reloadData()
  }
  
  
  
  func updateOrders() {
    let indexPath = IndexPath(item: selectedIndex, section: 0)
    collectionView.reloadItems(at: [indexPath])
  }


  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }


  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    var visibleRect = CGRect()

    visibleRect.origin = collectionView.contentOffset
    visibleRect.size = collectionView.bounds.size

    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

    let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!

    weekView.scrollToItem(at: visibleIndexPath)

  }


  func weekViewDidSelectDate(index: Int, date: Date) { //選定的日期
    selectedIndex = index
    collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
    pickedDate = date
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
    let string = formatter.string(from: pickedDate)
    print("WeekView \(string)")
  }
  
  



}


extension DayOrderVC: UICollectionViewDataSource, UICollectionViewDelegate {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return 100
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagecell", for: indexPath) as! TableViewItemCell

    cell.setData(begin: openTime, end: closeTime, date: pickedDate)

    return cell
  }


 
}

extension DayOrderVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "putordervc") as! PutOrderVC
    
    let date = indexToDate(row: indexPath.row)
    guard isWorkDay(date:date) else {
      return
    }
    
    
    print(date.string(inDateStyle: .short, andTimeStyle: .short) )
    vc.beginTime = date
    
    show(vc, sender: nil)
    
  }
  
  func isWorkDay(date:Date) -> Bool {
    let dayofweek =  Calendar.current.dateComponents([.weekday], from: date).weekday
    return  workDays![dayofweek! - 1 ] //since sunday is 1, to satday:6
    
  }
  
  func indexToDate(row:Int) ->Date {
    let calendar = Calendar.current
 //   calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
    var components = DateComponents()
    components.year = pickedDate.year
    components.month = pickedDate.month
    components.day = pickedDate.day
    components.hour = row + openTime
    components.minute = 0
    print(components.day!,components.hour!)
    let date =  calendar.date(from: components)!
    let hourFromGMT = Int(TimeZone.current.secondsFromGMT()/3600)
   // let taiwanDate = (date + hourFromGMT.hours)! +  8.hours
   // return taiwanDate!
    return date
  }

}
