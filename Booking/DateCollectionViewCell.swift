

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
  var dayLabel: UILabel!
  // rgb(128,138,147)
  var numberLabel: UILabel!
  var darkColor = UIColor(red: 0, green: 22.0 / 255.0, blue: 39.0 / 255.0, alpha: 1)
  var highlightColor = UIColor(red: 0 / 255.0, green: 199.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)
  let calendar = Calendar(identifier: .gregorian)

  override var isSelected: Bool {
    didSet {
      dayLabel.textColor = isSelected == true ? .white : darkColor.withAlphaComponent(0.5)
      numberLabel.textColor = isSelected == true ? .white : darkColor
      contentView.backgroundColor = isSelected == true ? highlightColor : .white
      contentView.layer.borderWidth = isSelected == true ? 0 : 1
    }
  }



  override func awakeFromNib() {
    dayLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width - 10, height: 20))
    dayLabel.font = UIFont.systemFont(ofSize: 12)
    dayLabel.textAlignment = .center

    numberLabel = UILabel(frame: CGRect(x: 5, y: 20, width: frame.width - 10, height: 40))
    numberLabel.font = UIFont.systemFont(ofSize: 10)
    numberLabel.textAlignment = .center

    contentView.addSubview(dayLabel)
    contentView.addSubview(numberLabel)
    contentView.backgroundColor = .lightGray
    contentView.layer.cornerRadius = 3
    contentView.layer.masksToBounds = true
    contentView.layer.borderWidth = 1
  }


  func populateItem(date: Date, highlightColor: UIColor, darkColor: UIColor) {
    self.highlightColor = highlightColor
    self.darkColor = darkColor

    let dateFormatter = DateFormatter()
  //  dateFormatter.locale = Locale(identifier: "zh-TW")
    dateFormatter.dateFormat = "EEE"
    dayLabel.text = dateFormatter.string(from: date)
    if case 2...6 = calendar.component(.weekday, from: date) {
      dayLabel.textColor = .blue
    } else {
      dayLabel.textColor = .red
    }

    let numberFormatter = DateFormatter()
  //  numberFormatter.locale = Locale(identifier: "zh-TW")
    numberFormatter.dateFormat = "MMM d"
    numberLabel.text = numberFormatter.string(from: date)
    numberLabel.textColor = isSelected == true ? .white : darkColor

    contentView.layer.borderColor = darkColor.withAlphaComponent(0.2).cgColor
  }

}
