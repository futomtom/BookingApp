

import UIKit
import Timepiece

class OrdersOfDate {
  var date: String = ""
  var orders: [Order] = []

}


class DayIncome {
  var date: String = ""
  var income: Int = 0
}



class FireService {
  static let sharedInstance: FireService = FireService()
  let database = FIRDatabase.database()
  var totalProducts: [Product] = []
  var totalOrders: [OrdersOfDate] = []
  var setting: Settings?
  lazy var currentUser: FIRUser = { return FIRAuth.auth()?.currentUser }()!
  lazy var ordersRef: FIRDatabaseReference = { return self.database.reference(withPath: FirePath.ordersPath) }()
  lazy var productsRef: FIRDatabaseReference = { return self.database.reference(withPath: FirePath.productsPath) }()
  lazy var settingsRef: FIRDatabaseReference = { return self.database.reference(withPath: FirePath.settingsPath) }()
  lazy var storageRef: FIRStorageReference = { return FIRStorage.storage().reference() }()


  var openTimeHour: Int?
  var openTimeMinute: Int?
  var closeTimeHour: Int?
  var closeTimeMinute: Int?
  var workDays: Array<Bool> = Array(repeating: false, count: 7)


  init() {
    getTotalProducts { products in }
    getSettingsValue { settings in
      self.setting = settings
      self.openTimeHour = settings.openTime.getHour()
      self.closeTimeHour = settings.closeTime.getHour()
      self.convertToWorkDay(string: settings.workDays)



    }
  }



  func convertToWorkDay(string: String) {
    let weekdays: [String] = string.components(separatedBy: ",")
    for c in weekdays {
      if let i = Int(c) {
        workDays[i] = true
      }
    }
  }



  func getTotalProducts(completionHandler: @escaping (_: [Product]) -> Void) {
    print("run again")

    productsRef.queryOrdered(byChild: "shipped").observe(.value, with: { snapshot in
      self.totalProducts.removeAll()
      for item in snapshot.children {
        let product = Product(snapshot: item as! FIRDataSnapshot)
        self.totalProducts.append(product)
      }
      completionHandler(self.totalProducts)
    })
  }

  func getTotalOrders(completionHandler: @escaping (_: [OrdersOfDate]) -> Void) {
    //Firebase Path Orders/Date/order
    ordersRef.queryOrderedByKey().observe(.value, with: { snapshot in
      self.totalOrders.removeAll()
       print("step1 \(self.totalOrders.count)")
      guard  snapshot.childrenCount > 0 else {
        completionHandler(self.totalOrders)
        return 
      }
      for i in 0...snapshot.childrenCount - 1 { //Date node
        let child = snapshot.children.nextObject()
        self.getOrderofDate(snapshot: (child as! FIRDataSnapshot), handler: { ordersOfDate in
          self.totalOrders.append(ordersOfDate)
          if i == (snapshot.childrenCount - 1) {
             print("step2 \(self.totalOrders.count)")
            completionHandler(self.totalOrders) //收集完order of date 才呼叫 completion
          }
        })
      }
    })
  }

  func getOrderofDate(snapshot: FIRDataSnapshot, handler: @escaping (_: OrdersOfDate) -> Void) {
    snapshot.ref.queryOrdered(byChild: "openTime").observeSingleEvent(of: .value, with: { snapshot in
      let ordersOfDate = OrdersOfDate()
      ordersOfDate.date = snapshot.key
      for order in snapshot.children {
        let order = Order(snapshot: order as! FIRDataSnapshot)
        ordersOfDate.orders.append(order)
      }
      handler(ordersOfDate)
    })
  }

  func saveDayIncome(date: Date, handler: @escaping (_: Int) -> Void) {
    var dayIncome = 0
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yy"
    let dateString = dateFormatter.string(from: date)
    print(dateString)
    let orderDateRef = ordersRef.child(dateString) //date level
    orderDateRef.observe(.value, with: { snapshot in
      if snapshot.value is NSNull {
      } else {
        for order in snapshot.children { //date/orders   level
          let dict = (order as! FIRDataSnapshot).value as? [String: AnyObject]
          let income = dict?["totalPrice"] as! Int
          dayIncome += income
        }
        let ref = self.database.reference(withPath: FirePath.incomePath)
        ref.child(dateString).setValue(["DayIncome": dayIncome])
        handler(dayIncome)
      }
    })

  }

  func getDayIncome(date: Date, handler: @escaping (_: Int) -> Void) {
    let ref = database.reference(withPath: FirePath.incomePath)
    ref.observeSingleEvent(of: .value, with: { snapshot in
      if snapshot.exists() {
        let Dict = snapshot.value as! [String: AnyObject]
        let income = Dict["DayIncome"] as! Int
        handler(income)
      }
    })
  }


  func getIncomeSUM(from: Date, to: Date, handler: @escaping (_: [Int]) -> Void) -> Int {
    var incomeSUM = 0
    let days = daysBetween(start: from, end: to)
    for i in 0..<days {
      getDayIncome(date: (from + i.days)!, handler: { income in
        incomeSUM += income
      })
    }
    return incomeSUM
  }

  func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
  }


  func getOrdersByDate(date: Date, completionHandler: @escaping (_: [Order]) -> Void) {
    var orders: [Order] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yy"
    let dateString = dateFormatter.string(from: date)
    print(dateString)
    let orderDateRef = ordersRef.child(dateString) //date level
    orderDateRef.observe(.value, with: { snapshot in
      if snapshot.value is NSNull {
        completionHandler(orders)
      } else {
        for order in snapshot.children { //date/orders   level
          let order = Order(snapshot: order as! FIRDataSnapshot)
          orders.append(order)
        }
        completionHandler(orders)
      }
    })

  }

  func addProduct(product: Product) {
    productsRef.childByAutoId().setValue(product.toAny())

  }

  func addOrder(order: Order) {
    let key = ordersRef.child(order.startDate).childByAutoId().key
    var order = order
    order.orderID = key
    let ref = ordersRef.child(order.startDate).child(key)
    ref.setValue(order.toAny())
    var index = 0
    for product in order.products {
      ref.child("Products").child("\(index)").setValue(product.toAny())
      index += 1
    }
  }


  func getSettings() -> Settings {
    return setting!
  }

  func getSettingsValue(completionHandler: @escaping (_: Settings) -> Void) {

    settingsRef.observeSingleEvent(of: .value, with: { snapshot in
      if snapshot.exists() {
        self.setting = Settings(snapshot: snapshot)
        completionHandler(self.setting!)
      } else {
        self.setting = Settings(workDays: "1,2,3,4,5,6", openTime: "7:00", closeTime: "21:00")
        completionHandler(self.setting!)
      }
    })
  }

  func UpdateSetting(settings: Settings) {
    settingsRef.setValue(settings.toAny())

  }

  func uploadtoFirebase(Path: URL) {

    let serverPath = FIRAuth.auth()!.currentUser!.uid + "/\(Path.lastPathComponent)"
    // [START uploadimage]
    storageRef.child(serverPath)
      .putFile(Path, metadata: nil) {
        (metadata, error) in
        if let error = error {
          print("Error uploading: \(error)")
          return
        }
        print("uploaded \(serverPath)")
    }
  }

  func downloadFromFirebase(Path: String, block: @escaping (UIImage) -> Void) {
    let serverPath = FIRAuth.auth()!.currentUser!.uid + "/\(Path)"
    let fileRef = storageRef.child(serverPath)

    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    fileRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
      if let error = error {
        // Uh-oh, an error occurred!
      } else {
        // Data for "images/island.jpg" is returned
        let image = UIImage(data: data!)
        block(image!)
      }
    }

  }



}


