import Foundation

struct ServicePersonnel {

    let key: String
    let name: String
    let ID: String
    let info: String
    let user: String
    let ref: FIRDatabaseReference?

    init(Name: String, ID: String, Info: String, creator user: String, key: String = "") {
        self.name = Name
        self.ID = ID
        self.info = Info
        self.key = key
        self.user = user
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        ID = snapshotValue["ServicePersonnelID"] as! String
        name = snapshotValue["ServicePersonnelName"] as! String
        info = snapshotValue["ServicePersonnelInfo"] as! String
        user = snapshotValue["creator"] as! String
        ref = snapshot.ref
    }

    func toAny() -> Any {
        return [
                "ServicePersonnelName": name,
                "ServicePersonnelID": ID,
                "ServicePersonnelInfo": info,
                "creator": user
        ]
    }

}
