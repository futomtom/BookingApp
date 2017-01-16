import UIKit

class checkListItem: NSObject {
    var text = ""
    var checked = false

    override init() {
        super.init()
    }



    func toggleChecked() {
        checked = !checked
    }


}


class Checklist: NSObject {
    var name = ""
    var items = [checkListItem]()
    var ServiceName: String

    convenience init(name: String) {
        self.init(name: name, ServiceName: "   ")
    }

    init(name: String, ServiceName: String) {
        self.name = name
        self.ServiceName = ServiceName
        super.init()
    }



    func allbyString() -> String {
        var rel: String
        var textSeparate = self.ServiceName.components(separatedBy: "/")
        var text: String = ""
        for a in textSeparate {
            text = text + a
        }

        rel = self.name + text
        return rel
    }

    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}


