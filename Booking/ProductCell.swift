//
//  ProductCell.swift
//  Booking
//
//  Created by Alex on 11/15/16.
//  Copyright © 2016 Alex Inc. All rights reserved.
//

import UIKit


class ProductCell: UITableViewCell {

  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var nameLable: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var checkimageV: UIImageView!

  @IBOutlet weak var ratingView: FloatRatingView!

  @IBOutlet weak var describeLabel: UILabel!
  @IBOutlet weak var sold: UILabel!
  @IBOutlet weak var oldPriceLabel: UILabel!
  let fireService = FireService.sharedInstance
  
  override func awakeFromNib() {
    ratingView.emptyImage = UIImage(named: "heartempty")
    ratingView.fullImage = UIImage(named: "heartFilled")
    ratingView.contentMode = UIViewContentMode.scaleAspectFit
    ratingView.maxRating = 5
    ratingView.minRating = 1
    
    ratingView.editable = false
    ratingView.halfRatings = true
    ratingView.floatRatings = false
  }





  func displayOldPrice(product: Product) {
    if product.oldPrice == 0 {
      oldPriceLabel.isHidden = true
      return
    }
   
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(product.oldPrice)")
    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
    oldPriceLabel.attributedText = attributeString
  }



  func displayProduct(product: Product) {
    
    displayOldPrice(product:product)
    nameLable.text = product.productName
    describeLabel.text = "泰式古法舒活按摩，一吋吋的放鬆各處肌肉，將疲憊痠痛的筋骨給予伸展，舒刮順氣讓身心一同感受暢快輕盈，下殺優惠麻吉千萬別錯過"
    time.text = "\(product.duration)分鐘"
    price.text = "$\(product.price)元"
    fireService.downloadFromFirebase(Path: product.imageName) { image in
      self.productImageView.image = image
    }
    ratingView.rating = product.rate
//    checkimageV.isHidden = item.shipped
  }
}

class OrderCell: UITableViewCell {

  @IBOutlet weak var nameLable: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var checkimageV: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!




  func displayOrder(order: Order) {
    nameLable.text = order.userName
    contentLabel.text = order.content
    time.text = "at:\(order.beginTime)"
    price.text = "$\(order.totalPrice)"
    durationLabel.text = "Duration:\(order.duration)分"
    checkimageV.isHidden = true // order.shipped
   
  }
}



