//
//  weelview.swift
//  CalendarTableView
//
//  Created by alexfu on 11/6/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit
import Timepiece

protocol WeekViewDelegate {
  func weekViewDidSelectDate(index: Int, date: Date)
}


class WeekView: UIView {
  var displayDays: CGFloat = 7
  // 7 days a week
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var titleLabel: UILabel!
  var bossMode = false

 
  private var maximumDate: Date!

  internal var calendar: Calendar = .current
  internal var dates: [Date]! = []
  internal var components: DateComponents!

//    public var selectedDate = Date()
  public var selectedIndex = IndexPath(row: 0, section: 0)
  public var dateFormat = "HH:mm dd/MM/YYYY"
  var delegate: WeekViewDelegate!

  public var backgroundViewColor: UIColor = .clear {
    didSet {
      backgroundColor = backgroundViewColor
    }
  }

  public var highlightColor = UIColor(red: 0 / 255.0, green: 199.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)

  public var darkColor = UIColor(red: 0, green: 22.0 / 255.0, blue: 39.0 / 255.0, alpha: 1)

  public var daysBackgroundColor = UIColor(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, alpha: 1)


  override func awakeFromNib() {
    backgroundColor = daysBackgroundColor

  }

  override func layoutSubviews() {
    print("layout")
    configureView()
    if bossMode {
       scrollToItem(at: IndexPath(item: 20, section: 0))
    }
  }


  private func configureView() {
     let  minimumDate = bossMode ? Date() - 20.days : Date()
  
    setTitlefrom(date: Date())  //is needed
    maximumDate = Date() + 20.days

    // day collection view
    let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    let width = floor((frame.width) / displayDays) - 1
    layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    layout.itemSize = CGSize(width: width, height: width)

    fillDates(fromDate: minimumDate!, toDate: maximumDate)
  }

  func fillDates(fromDate: Date, toDate: Date) {

    var dates: [Date] = []
    var days = DateComponents()

    var dayCount = 0
    repeat {
      days.day = dayCount
      dayCount += 1
      guard let date = calendar.date(byAdding: days, to: fromDate) else {
        break;
      }
      if date.compare(toDate) == .orderedDescending {
        break
      }
      dates.append(date)
    } while (true)

    self.dates = dates
    collectionView.reloadData()

  }

 
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    alignScrollView(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      alignScrollView(scrollView)
    }
  }

  func alignScrollView(_ scrollView: UIScrollView) {
    if let collectionView = scrollView as? UICollectionView {
      let centerPoint = CGPoint(x: 10 + collectionView.contentOffset.x, y: 50);
      if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
        // automatically select this item and center it to the screen
        // set animated = false to avoid unwanted effects
        clearPreviousSelectedCell(indexPath: selectedIndex)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        if let cell = collectionView.cellForItem(at: indexPath) {
          let offset = CGPoint(x: cell.center.x - cell.contentView.frame.width / 2, y: 0)
          collectionView.setContentOffset(offset, animated: false)
        }

        selectedIndex = indexPath
      }
      collectionView.reloadData()
      setTitlefrom(date: dates[selectedIndex.item])
      delegate?.weekViewDidSelectDate(index: selectedIndex.item, date: dates[selectedIndex.item])
    }
  }
  
  func clearPreviousSelectedCell(indexPath:IndexPath) {
    let cell = collectionView(collectionView, cellForItemAt: selectedIndex) as! DateCollectionViewCell
    cell.isSelected = false
   // collectionView.reloadItems(at: [indexPath])
    
    
  }
}

extension WeekView: UICollectionViewDataSource, UICollectionViewDelegate {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(dates.count)
    return dates.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell

    let date = dates[indexPath.item]

    cell.isSelected = selectedIndex == indexPath ? true : false

    cell.populateItem(date: date, highlightColor: highlightColor, darkColor: darkColor)

    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    collectionView.reloadData()
    setTitlefrom(date: dates[indexPath.item])
    delegate?.weekViewDidSelectDate(index: indexPath.item, date: dates[indexPath.item])

  }
  func setTitlefrom(date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d"
    let dateString = dateFormatter.string(from: date)
    if bossMode {
      let fireService = FireService.sharedInstance
      fireService.saveDayIncome(date: date) { income in
        self.titleLabel.text = dateString + "  訂單共\(income)元"
      }
    } else {
      titleLabel.text = dateString
    }
  }


  func scrollToItem(at indexPath: IndexPath) {

    if selectedIndex != indexPath {
      selectedIndex = indexPath
      //        print(indexPath.row)
      collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
      collectionView.reloadData()
    }

  }


}
