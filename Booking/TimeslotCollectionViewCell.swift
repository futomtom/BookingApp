import UIKit

class TimeslotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dotStackView: UIStackView!
    override func awakeFromNib() {

        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3.0
        userLabel.text = ""

    }

    func displayData(order: Order) {
        userLabel.text = order.userName
       fillDots(order:order)
    
        //   isUserInteractionEnabled = false

    }
  
  func clearData() {
    userLabel.text = ""
    for view in dotStackView.arrangedSubviews {
      dotStackView.removeArrangedSubview(view)
    }
    dotStackView.isHidden = true
  }


    func fillDots(order: Order) {
        let colors: [UIColor] = [.red, .yellow, .blue]
        var dots: [UIView] = Array(repeating: UIView(), count: order.products.count)
      for view in dotStackView.arrangedSubviews {
        dotStackView.removeArrangedSubview(view)
      }
     
       print("\(order.products.count) orders")
        for i in 0..<order.products.count {
         
            dots[i] = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            dots[i].backgroundColor = colors[i]
            dots[i].layer.cornerRadius = 5

            dotStackView.addArrangedSubview( dots[i])
        }
      dotStackView.isHidden = false 

    }
}
