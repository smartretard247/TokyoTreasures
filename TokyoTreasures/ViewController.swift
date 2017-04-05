//
//  ViewController.swift
//  TokyoTreasures
//
//  Created by Jeezy on 3/17/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol {
    //Properties
    var currentUrl: String!
    var feedItems: NSArray = NSArray()
    var selectedItem: OrderModel = OrderModel()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let av = self.activityView {
            av.hidesWhenStopped = true
        }
        toggleActivityAnimation(true)
        
        //set delegates and initialize homeModel
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        self.currentUrl = "http://203.105.90.20/ssa/service.php"
        initHomeModel(withUrl: self.currentUrl)
        
        self.title = "Order Status"
        self.listTableView.addSubview(self.refreshControl)
        toggleActivityAnimation(false)
    }
    
    func toggleActivityAnimation(_ activityAnimating: Bool) {
        if let av = self.activityView {
            if(activityAnimating) {
                av.startAnimating()
            } else {
                av.stopAnimating()
            }
        }
    }
    
    func initHomeModel(withUrl: String) {
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.setPath(withUrl)
        homeModel.downloadItems()
    }
    
    @IBAction func switchToHistoricalView() {
        self.currentUrl = "http://203.105.90.20/ssa/history.php"
        initHomeModel(withUrl: self.currentUrl)
        self.listTableView.reloadData()
    }
    
    @IBAction func switchToServicingView() {
        self.currentUrl = "http://203.105.90.20/ssa/service.php"
        initHomeModel(withUrl: self.currentUrl)
        self.listTableView.reloadData()
    }
    
    @IBAction func switchView() {
        toggleActivityAnimation(true)
        switch self.currentUrl {
        case "http://203.105.90.20/ssa/service.php":
            self.currentUrl = "http://203.105.90.20/ssa/history.php"
            self.title = "Order Status (Historical)"
        default:
            self.currentUrl = "http://203.105.90.20/ssa/service.php"
            self.title = "Order Status"
        }
        initHomeModel(withUrl: self.currentUrl)
        self.listTableView.reloadData()
        toggleActivityAnimation(false)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        initHomeModel(withUrl: self.currentUrl)
        self.listTableView.reloadData()
        refreshControl.endRefreshing()
    }
        
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count // Return the number of feed items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicCell" // Retrieve cell
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let item: OrderModel = feedItems[indexPath.row] as! OrderModel // Get the location to be shown
        myCell.textLabel!.text = "\(item.id!) - \(item.nameOnOrder!) - \(item.notes ?? "Other")" // Get references to labels of cell
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = feedItems[indexPath.row] as! OrderModel
        let destVC = storyboard?.instantiateViewController(withIdentifier: "OrderController") as! OrderController
        destVC.loadedOrder = self.selectedItem
        navigationController?.pushViewController(destVC, animated: true)
    }
}
