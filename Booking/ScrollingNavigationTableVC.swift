import UIKit
import AMScrollingNavbar
/**
 A custom `UIViewController` that implements the base configuration.
 */
open class ScrollingNavigationTableVC: UITableViewController {

  // MARK: - ScrollView config

  /**
   On appear calls `showNavbar()` by default
   */
  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.showNavbar(animated: true)
    }
  }

  /**
   On disappear calls `stopFollowingScrollView()` to stop observing the current scroll view, and perform the tear down
   */
  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
      //use func`viewDidDisappear`, below func `stopFollowingScrollView` never been executed
      navigationController.stopFollowingScrollView()
    }
  }

  /**
   Calls `showNavbar()` when a `scrollToTop` is requested
   */
  open override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.showNavbar(animated: true)
    }
    return true
  }

}
