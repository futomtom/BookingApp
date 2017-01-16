//
//  SegmentViewController.swift
//  test2
//
//  Created by alexfu on 11/26/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import SideMenu

class IncomeVC: UIViewController {
    let fireService = FireService.sharedInstance
  var income:Int = 0 


  var currentPage = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    setSegmentTitle()
    
   fireService.saveDayIncome(date: Date()) { income in
    self.income = income
    print( income)
    }

  }
  

  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)

  }

  func setSegmentTitle() {
    let segment: UISegmentedControl = UISegmentedControl(items: ["日", "周"])
    segment.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
    segment.selectedSegmentIndex = 0;
    segment.addTarget(self, action: #selector(SegmentViewController.segmentedValueChanged(segment:)), for: .valueChanged)
    navigationItem.titleView = segment
  }

 




  func segmentedValueChanged(segment: UISegmentedControl) {
    let index = segment.selectedSegmentIndex
    
  }


}

