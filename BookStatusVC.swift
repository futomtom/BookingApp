//
//  BookStatusVC.swift
//  
//
//  Created by Alex on 11/7/16.
//
//

import UIKit

class BookStatusVC: UIViewController ,weekViewDelegate{

    @IBOutlet weak var weekView: weekview!
    @IBOutlet weak var collectionView: UICollectionView!
    let startTime:Int = 9
    let endTime:Int = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout:UICollectionViewFlowLayout = collectionView.collectionViewLayout  as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: collectionView.bounds.width , height: collectionView.bounds.height)
        weekView.delegate = self
        
  
    }
    


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        weekView.scrollToItem(at: visibleIndexPath)

    }
    
    
    func weekViewDidSelectDate(index:Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
        
    }



}


extension BookStatusVC: UICollectionViewDataSource, UICollectionViewDelegate {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
    return 100
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagecell", for: indexPath) as! tableviewItemCell
    cell.settime(start: 8, end: 17)
    
    cell.layer.borderColor=UIColor.blue.cgColor
    cell.layer.borderWidth=1
    
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //workaround to center to every cell including ones near margins
  }
  
}
