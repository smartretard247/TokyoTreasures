//
//  TodayViewController.swift
//  TodaysTreasures
//
//  Created by Jeezy on 3/24/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: ViewController, NCWidgetProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else { //expanded
            self.preferredContentSize = CGSize(width: maxSize.width, height: 220)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicCell" // Retrieve cell
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let item: OrderModel = feedItems[indexPath.row] as! OrderModel // Get the location to be shown
        myCell.textLabel!.text = "\(item.nameOnOrder!) - \(item.notes ?? "Custom")" // Get references to labels of cell
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = feedItems[indexPath.row] as! OrderModel
        let destVC = storyboard?.instantiateViewController(withIdentifier: "TodayOrderController") as! TodayOrderController
        destVC.loadedOrder = self.selectedItem
        self.present(destVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(destVC, animated: true)
    }
}
