

import Foundation


extension String {
  
  func getHour() -> Int {
    let hour = 8
    let colon: Character = ":"
    if let idx = self.characters.index(of: colon) {
      let hour = Int( self.substring(to: idx))
      return hour ?? 8
    }
    return hour
  }
  
  
}

