//
//  workingDay.swift
//  Booking
//
//  Created by AlexFu on 2016/11/16.
//  Copyright © 2016年 Alex Inc. All rights reserved.
//

import Foundation

enum WeekDay: Int {
  case Monday = 0
  case Tuesday = 1
  case Wednesday = 2
  case Thursday = 3
  case Friday = 4
  case Saturday = 5
  case Sunday = 6
}

struct Settings {
  var workDays: String
  var openTime: String
  var closeTime: String
  var address: String
  var phone: String
  /*
    let key: String
    let ref: FIRDatabaseReference?
*/

  init(workDays: String, openTime: String, closeTime: String,address:String = "台北市",phone:String = "09327864") {
    self.workDays = workDays
    self.openTime = openTime
    self.closeTime = closeTime
    self.address = address
    self.phone = phone
    /*
        self.key = ""
        self.ref = nil
 */
  }
  init(snapshot: FIRDataSnapshot) {
    //   key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    workDays = snapshotValue["workDays"] as! String
    openTime = snapshotValue["openTime"] as! String
    closeTime = snapshotValue["closeTime"] as! String
    address = snapshotValue["address"] as! String
    phone =  snapshotValue["phone"] as! String
    

    //  ref = snapshot.ref
  }

  func toAny() -> Any {
    return [
      "workDays": workDays,
      "openTime": openTime,
      "closeTime": closeTime,
      "address": address,
      "phone": phone
    ]
  }
  func getStartHour() -> Int {
    return openTime.getHour()
  }

  func getEndHour() -> Int {
    return closeTime.getHour()
  }







}
