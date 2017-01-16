//
//  TextFieldCell.swift
//  Booking
//
//  Created by Alex on 11/25/16.
//  Copyright © 2016 Alex Inc. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  var result: String?

  override open func awakeFromNib() {
    super.awakeFromNib()
    textField.delegate = self

    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
    toolBar.barStyle = UIBarStyle.default
    toolBar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pressDone))]
    toolBar.sizeToFit()

    textField.inputAccessoryView = toolBar

  }

  func pressDone() {
    textField.resignFirstResponder()
    result = textField.text!
  }

  func setKeyboardType(type: UIKeyboardType) {
    textField.keyboardType = type

    textField.textAlignment = type == .numberPad ? .right : .left
  }

  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    textField.becomeFirstResponder()
  }

  open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    result = textField.text!
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    result = textField.text!
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    result = textField.text!
  }
  
  


}
