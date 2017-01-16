//
//  MyUser.swift
//  Booking
//
//  Created by AlexFu on 2016/11/16.
//  Copyright © 2016年 Alex Inc. All rights reserved.
//

import Foundation
import FirebaseAuth
class User:FIRUser {
  //FIRUser 已經就有  uid,email,displayName,photoURL
  var mobile:String

  init(authData: FIRUser, mobile:String ) {
    self.mobile = mobile
    
  }

  func toAny() -> Any {
    return [
      "displayName": displayName,
      "email": email,
      "uid": uid,
      "mobile": mobile
    ]
  }

}
