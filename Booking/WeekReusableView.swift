//
//  WeekReusableView.swift
//  test2
//
//  Created by Alex on 11/10/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import Timepiece

protocol WeekReusableViewDelegate {
  func pageChange(pageNum:Int)
  
  
}

class WeekReusableView: UICollectionReusableView {
  internal var calendar: Calendar = .current
  internal var dates: [Date]! = []
  internal var components: DateComponents!
  public var selectedIndex = IndexPath(row: 0, section: 0)
  let weekday = 5
  @IBOutlet weak var collectionView: UICollectionView!
  public var highlightColor = UIColor(red: 0 / 255.0, green: 199.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)
  public var darkColor = UIColor(red: 0, green: 22.0 / 255.0, blue: 39.0 / 255.0, alpha: 1)
  public var daysBackgroundColor = UIColor(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, alpha: 1)
  public var delegate:WeekReusableViewDelegate?
  let daysAgo = 30

  override func awakeFromNib() {
    let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    //        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    let columns = CGFloat(weekday)
    let width = floor(bounds.width / columns) - 2
    layout.itemSize = CGSize(width: width, height: width)
    let now = Date()
    backgroundColor = .blue //daysBackgroundColor
    let minimumDate = now - daysAgo.days
    let maximumDate = now + 30.days
    fillDates(fromDate: minimumDate!, toDate: maximumDate!)
  }
  
  override func layoutSubviews() {
    scrolltoToday()
  }
  
  func scrolltoToday() {
    let todayPos = IndexPath(item: 30, section: 0)    // since we start from 10 days ago
    collectionView.scrollToItem(at: todayPos, at: .left, animated: true)
    collectionView.isPagingEnabled = true
  }
  

  
  func fillDates(fromDate: Date, toDate: Date) {
    var dates: [Date] = []
    let days = daysBetween(start: fromDate, end: toDate)
    for i in 0..<days {
      let date = fromDate + i.days
      dates.append(date!)
    }

    self.dates = dates
  }

  func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
  }


   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let x = collectionView.contentOffset.x
    let w = collectionView.bounds.size.width
    let currentPage = Int(ceil(x/w))
    delegate?.pageChange(pageNum: currentPage)
  }


  }


extension WeekReusableView: UICollectionViewDataSource, UICollectionViewDelegate {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 //   print(dates.count)
    return dates.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekday", for: indexPath) as! DateCollectionViewCell

    let date = dates[indexPath.item]

    cell.isSelected =  false

    cell.populateItem(date: date, highlightColor: highlightColor, darkColor: darkColor)

    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    collectionView.reloadData()


  }
}
