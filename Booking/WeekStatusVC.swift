//
//  WeekCollectionViewController.swift
//  test2
//
//  Created by Alex on 11/10/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import SideMenu
import Timepiece

private let reuseIdentifier = "Cell"

class WeekStatusVC: UICollectionViewController, WeekReusableViewDelegate {
  var daysInScreen = 5 //改一週顯示幾天
  let fireService = FireService.sharedInstance
  var openTime = 7
  var closeTime = 17
  var ordersOf5Days:[[Order]] = Array(repeating: [] , count: 5)   // since displayDays = 5
  let daysAgo = 30 //WeekReusableView  use this number too. 
  


  override func viewDidLoad() {
    super.viewDidLoad()
    
    openTime = fireService.openTimeHour!
    closeTime = fireService.closeTimeHour!

    
    clearsSelectionOnViewWillAppear = false
    setupLayout()
    getPageData(page:Int(daysAgo/5))   //
    let date = Date()
    fireService.getOrdersByDate(date: date, completionHandler: { orders in
      print (orders.count)
    })
  }
  
  func getPageData(page:Int) {     //把資料填入
    let offset = page * 5
    let startDate = (Date() - daysAgo.days)! + offset.days
    print(startDate?.string(inDateStyle: .short, andTimeStyle: .short))
    for i in 0...4 {
      let date = startDate! + i.days
      ordersOf5Days[i].removeAll()
      fireService.getOrdersByDate(date: date!, completionHandler: { orders in
        print("date \(date!.day) count=\(orders.count)")
        self.ordersOf5Days[i] = orders
        if i == 4 {
          self.collectionView?.reloadData()
        }
      })
    }
  }





  func setupLayout() {

    let layout: UICollectionViewFlowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    let columns = CGFloat(daysInScreen)
    let width = floor(view.bounds.width / columns) - 2 //item width
    layout.itemSize = CGSize(width: width, height: width * 1.2)
    layout.sectionHeadersPinToVisibleBounds = true //sticky head
    layout.headerReferenceSize = CGSize(width: width, height: width + 4)
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    if kind == UICollectionElementKindSectionHeader {
     let  v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "head", for: indexPath) as! WeekReusableView
      v.delegate = self
      
     
      return v
    }
    
    return UICollectionReusableView()
  }

  func pageChange(pageNum:Int) {
    print("page = \(pageNum)")
       getPageData(page: pageNum)

  }


  // MARK: UICollectionViewDataSource


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return (closeTime - openTime + 1) * daysInScreen
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeslotCollectionViewCell
   
    let indexof5days = indexPath.item % 4
    let time = openTime + indexPath.item/5
    cell.hourLabel.text = "\(time)"
     print("\(indexPath.item) \(indexof5days)  \(time)")
    if ordersOf5Days[indexof5days].count > 0 {
      let items = ordersOf5Days[indexof5days].filter({ $0.beginTime.getHour() == time })
      if items.count > 0 {
        print("show data")
        cell.displayData(order: items[0])
      } else {
        cell.clearData()
      }
      
    }
    return cell
  }


}
