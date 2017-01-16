

import Foundation


class FirePath {
  static var  storePath:String!
  static var  productsPath:String!
  static var  userPath:String!
  static var  ordersPath:String!
  static var  infoPath:String!
  static var  settingsPath:String!
  static var  incomePath:String!
  
  
  static func setPath(storeID :String) {
    
    storePath = "Stores/store" + storeID
    productsPath = storePath + "/" + "Products"
    userPath = storePath + "/" + "Users"
    ordersPath = storePath + "/" + "Orders"
    infoPath = storePath + "/" + "Info"
    settingsPath = storePath + "/" + "Settings"
    incomePath = storePath + "/" + "Income"
  }
}
