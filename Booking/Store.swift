import Foundation

struct Store {

    let key: String
    let storeName: String
    let storeID: String
    let creator: String
    let ref: FIRDatabaseReference?

    init(storeName: String, creator user: String, storeID: String, key: String = "") {
        self.storeName = storeName
        self.storeID = storeID
        self.key = key
        self.creator = user
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        storeID = snapshotValue["storeID"] as! String
        storeName = snapshotValue["storeName"] as! String
        creator = snapshotValue["creator"] as! String
        ref = snapshot.ref
    }

    func toAny() -> Any {
        return [
                "productName": storeName,
                "storeID": storeID,
                "creator": creator
        ]
    }

}
