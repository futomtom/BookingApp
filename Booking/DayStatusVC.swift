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

class DayStatusVC: UIViewController, WeekViewDelegate {

  @IBOutlet weak var weekView: WeekView!
  @IBOutlet weak var collectionView: UICollectionView!

  let fireService = FireService.sharedInstance
  var openTime = 7
  var closeTime = 17
  var pickedDate = Date()
  var selectedIndex = 0
  var settings:Settings!

 


  override func viewDidLoad() {
    super.viewDidLoad()

    settings  = fireService.getSettings()
    openTime = settings.getStartHour()
    closeTime = settings.getEndHour()

    let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.sectionHeadersPinToVisibleBounds = true //sticky head
    layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    weekView.delegate = self
    weekView.bossMode = true
    
  }
  
  func getTimeSetting() {
  /*
    fireService.getSettings { settings in
     
    }
 */
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


extension DayStatusVC: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension DayStatusVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  
    let vc = storyboard?.instantiateViewController(withIdentifier: "putordervc") as! PutOrderVC
    
    let date = indexToDate(row: indexPath.row)
    print(date.string(inDateStyle: .short, andTimeStyle: .short) )
    vc.beginTime = date
    
    show(vc, sender: nil)
    
  }
  
  func indexToDate(row:Int) ->Date {
    let calendar = Calendar.current
 //   calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
    var components = DateComponents()
    let hourFromGMT = Int(TimeZone.current.secondsFromGMT()/3600)
    components.year = pickedDate.year
    components.month = pickedDate.month
    components.day = pickedDate.day
    components.hour = row + openTime
    components.minute = 0
    print(components.day!,components.hour!)
    let date =  calendar.date(from: components)!
    let taiwanDate = (date + hourFromGMT.hours)! +  8.hours
    return taiwanDate!
  }

}
