//
//  TimeSlotTableViewCell.swift
//  collect2
//
//  Created by Alex on 11/8/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

class TimeSlotTableViewCell: UITableViewCell {
  var begintime:Int = 0 {
    didSet {
      timeLabel.text = "\(begintime):00"
    }
    
  }
  
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    

  func displayData(order:Order) {
//    let empty  = UIColor(red:0.25, green:0.49, blue:0.84, alpha:0.25)
    let bookedColor = UIColor(red:1, green:0.49, blue:0.84, alpha:1)
    colorView.backgroundColor = bookedColor
    descriptionLabel.text = order.content
    isUserInteractionEnabled = false
  }
  
  func displayEmptyData() {
   
    colorView.backgroundColor = .white
    descriptionLabel.text = ""
    isUserInteractionEnabled = true
  }


  
}
