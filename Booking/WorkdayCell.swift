//
//  WorkdayCell.swift
//  Booking
//
//  Created by Alex on 11/24/16.
//  Copyright © 2016 Alex Inc. All rights reserved.
//

import UIKit



class WorkdayCell: UITableViewCell {

    var selectDays: [Bool] = []

    @IBOutlet weak var day0: BorderedButton!
    @IBOutlet weak var day1: BorderedButton!
    @IBOutlet weak var day2: BorderedButton!
    @IBOutlet weak var day3: BorderedButton!
    @IBOutlet weak var day4: BorderedButton!
    @IBOutlet weak var day5: BorderedButton!
    @IBOutlet weak var day6: BorderedButton!
   


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setButtons(status: [Bool]) {

        let buttons = [day0,day1, day2, day3, day4, day5, day6]
        for i in 0 ..< status.count {
            buttons[i]!.isSelected = status[i]
            buttons[i]!.tag = i
            setTwoLineButton(button: buttons[i]!)
        }
        selectDays = status
    }


    func setTwoLineButton(button: BorderedButton) {

        button.titleLabel!.lineBreakMode = .byWordWrapping
        button.titleLabel!.textAlignment = .center

    }

  

}
