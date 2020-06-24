/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class RootSplitViewController: UISplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let splitViewController = self
    let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
    splitViewController.delegate = self
    navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    splitViewController.primaryBackgroundStyle = .sidebar
  }
  
  var mainViewController: MainTableViewController? {
    guard let navigation = viewControllers.first as? UINavigationController else {
      return nil
    }
    
    return navigation.topViewController as? MainTableViewController
  }
  
  var entryViewController: EntryTableViewController? {
    guard let navigation = viewControllers.last as? UINavigationController else {
      return nil
    }

    return navigation.topViewController as? EntryTableViewController
  }
  
  private func title(for entry: Entry)-> String {
    let date = EntryTableViewCell.dateFormatter.string(from: entry.dateCreated)
    let time = EntryTableViewCell.timeFormatter.string(from: entry.dateCreated)
    return "\(date) \(time)"
  }
  
  @IBAction private func addEntry(_ sender: Any) {
    DataService.shared.addEntry(Entry())
  }
  
  @IBAction func share(_ sender: Any?) {
    entryViewController?.share(sender)
  }
}

// MARK: - UISplitViewControllerDelegate
extension RootSplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    guard let secondaryNavigationController = secondaryViewController as? UINavigationController,
      let entryTableViewController = secondaryNavigationController.topViewController as? EntryTableViewController else {
        return false
    }
    if entryTableViewController.entry == nil {
      return true
    }
    return false
  }
}