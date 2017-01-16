struct Product {

    let key: String
    let productName: String
    let creator: String
    let duration: Int
    let rate: Float
    let price: Int
    let oldPrice: Int
    let ref: FIRDatabaseReference?
    var vaild: Bool
    var imageName:String

  init(productName: String, duration: Int, price: Int,oldPrice: Int, creator: String, vaild: Bool, key: String = "", imageName:String,rate: Float = 0.0) {
        self.key = key
        self.duration = duration
        self.productName = productName
        self.price = price
        self.oldPrice = oldPrice
        self.rate = rate
        self.creator = creator
        self.vaild = vaild
        self.ref = nil
        self.imageName = imageName
    }

    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        productName = snapshotValue["productName"] as! String
        creator = snapshotValue["creator"] as! String
        duration = snapshotValue["duration"] as! Int
      if let oldPrice = snapshotValue["oldPrice"] as? Int {
        self.oldPrice = oldPrice
      } else {
        oldPrice = 0
      }
      
      if let rate = snapshotValue["rate"] as? Float {
        self.rate = rate
      } else {
        rate = 0.0
      }
      
        price = snapshotValue["price"] as! Int
        vaild = snapshotValue["vaild"] as! Bool
      if let imageName = snapshotValue["imageName"] as? String {
        self.imageName = imageName
      } else {
        imageName = "product1.jpg"
      }
      

        ref = snapshot.ref
    }

    func toAny() -> Any {
        return [
                "productName": productName,
                "duration": duration,
                "rate": rate,
                "price": price,
                "oldPrice": oldPrice,
                "creator": creator,
                "vaild": vaild,
                "imageName":imageName
        ]
    }

}
