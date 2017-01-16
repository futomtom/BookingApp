//
//  SegmentViewController.swift
//  test2
//
//  Created by alexfu on 11/26/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import SideMenu

class SegmentViewController: UIPageViewController {


  private(set) var vcs: [UIViewController]!
  var currentPage = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    setSegmentTitle()
    setupVC()
    
    dataSource = nil
    scrollToViewController(newIndex: 0)

  }
    


  func setSegmentTitle() {
    let segment: UISegmentedControl = UISegmentedControl(items: ["日", "周"])
    segment.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
    segment.selectedSegmentIndex = 0;
    segment.addTarget(self, action: #selector(SegmentViewController.segmentedValueChanged(segment:)), for: .valueChanged)
    navigationItem.titleView = segment
  }

  func setupVC() {
    let storyboard = UIStoryboard(name: "Booking", bundle: nil)
    let vc0 = storyboard.instantiateViewController(withIdentifier: "daystatusvc")
    let vc1 = storyboard.instantiateViewController(withIdentifier: "weekstatusvc")

    vcs = [vc0, vc1]

  }


  @IBAction func openMenu(_ sender: Any) {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }


  func segmentedValueChanged(segment: UISegmentedControl) {
    let index = segment.selectedSegmentIndex
    scrollToViewController(newIndex: index)
  }

  func scrollToViewController(newIndex: Int) {


    let direction: UIPageViewControllerNavigationDirection = newIndex >= currentPage ? .forward : .reverse
    currentPage = newIndex
    let vc = vcs[newIndex]
    scrollToViewController(viewController: vc, direction: direction)

  }

  private func scrollToViewController(viewController: UIViewController,
                                      direction: UIPageViewControllerNavigationDirection = .forward) {
    setViewControllers([viewController], direction: direction, animated: true)
    print(currentPage)

  }
}

/*
extension SegmentViewController:  UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before=\(currentPage)")
        return currentPage == 1 ? nil: PageviewControllers[0]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("after\(currentPage)")
        return currentPage == 0 ? nil: PageviewControllers[1]

    }

}
 */
