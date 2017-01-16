import Foundation

struct Order {

  var orderID: String
  var userName = ""
  let startDate: String
  let beginTime: String
  let endTime: String
  var content: String //all product name
  var duration: Int
  let totalPrice: Int
  let userID: String
  let ref: FIRDatabaseReference?
  var shipped: Bool
  var products: [Product] = []

  init(orderID: String,userName: String, content: String, creator userID: String, duration: Int, totalPrice: Int, shipped: Bool, beginTime: String = "", endTime: String = "", startDate: String = "", products: [Product]) {
    self.orderID = orderID
    self.userName = userName
    self.startDate = startDate
    self.beginTime = beginTime
    self.endTime = endTime
    self.content = content
    self.duration = duration
    self.totalPrice = totalPrice
    self.userID = userID
    self.shipped = shipped
    self.ref = nil
    self.products = products
  }

  init(snapshot: FIRDataSnapshot) {
    let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]
    orderID = snapshotValue["orderID"] as! String
    if let _ = snapshotValue["userName"] {
      userName = snapshotValue["userName"] as! String
    }

    content = snapshotValue["content"] as! String
    beginTime = snapshotValue["beginTime"] as! String
    startDate = snapshotValue["startDate"] as! String
    endTime = snapshotValue["endTime"] as! String
    duration = snapshotValue["duration"] as! Int
    totalPrice = snapshotValue["totalPrice"] as! Int
    userID = snapshotValue["userID"] as! String
    shipped = snapshotValue["shipped"] as! Bool
    //get Products
    let productsRef = snapshot.childSnapshot(forPath: "Products")
    for child in productsRef.children {
      let product = Product(snapshot: child as! FIRDataSnapshot)
      products.append(product)
    }

    ref = snapshot.ref
  }

  func toAny() -> Any {
    return [
      "orderID": orderID,
      "userName": userName,
      "beginTime": beginTime,
      "startDate": startDate,
      "endTime": endTime,
      "content": content,
      "duration": duration,
      "totalPrice": totalPrice,
      "userID": userID,
      "shipped": shipped
    ]
  }

}
