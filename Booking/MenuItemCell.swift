//
//  MenuItemCell.swift
//  
//
//  Created by Alex on 11/12/16.
//
//

import UIKit

class MenuItemCell: UITableViewCell {
  
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var iconV: UIImageView!
  
  func displayItem(item:menuItem)  {
    let image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
    
    iconV.image = image
    
    title.text = item.name
    
  }

  

}
