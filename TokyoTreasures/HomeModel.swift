//
//  HomeModel.swift
//  TokyoTreasures
//
//  Created by Jeezy on 3/17/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate {
    //properties
    weak var delegate: HomeModelProtocol!
    
    var data : NSMutableData = NSMutableData()
    
    var urlPath: String = "http://203.105.90.20/ssa/service.php" //path where service.php lives
    
    func setPath(_ to: String) {
        self.urlPath = to
    }
    
    func downloadItems() {
        let url: NSURL = NSURL(string: urlPath)!
        var session: URLSession!
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url as URL)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data as Data);
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        } else {
            print("Data downloaded")
            self.parseJSON()
        }
    }
    
    func parseJSON() {
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do {
            jsonResult = try (JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject).mutableCopy() as! NSMutableArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let orders: NSMutableArray = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let order = OrderModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let id = jsonElement["ID"] as? String,
                let orderDate = jsonElement["OrderDate"] as? String,
                let invoicePrice = jsonElement["InvoicePrice"] as? String,
                let shipping = jsonElement["Shipping"] as? String,
                let fee = jsonElement["Fee"] as? String,
                let profit = jsonElement["Profit"] as? String,
                let expecting = jsonElement["Expecting"] as? String,
                let processed = jsonElement["Processed"] as? String,
                let shipped = jsonElement["Shipped"] as? String,
                let name = jsonElement["NameOnOrder"] as? String {
                
                let address1 = jsonElement["Address1"] ?? "" as String?
                let address2 = jsonElement["Address2"] ?? "" as String?
                let city = jsonElement["City"] ?? "" as String?
                let state = jsonElement["State"] ?? "" as String?
                let zip = jsonElement["Zip"] ?? "" as String?
                let notes = jsonElement["Notes"] ?? "" as String?
                let email = jsonElement["Email"] ?? "" as String?
                    order.id = Int(id)
                    order.orderDate = orderDate
                    order.invoicePrice = Double(invoicePrice)
                    order.shipping = Double(shipping)
                    order.fee = Double(fee)
                    order.profit = Double(profit)
                    order.expecting = Double(expecting)
                    order.processed = Bool(processed)
                    order.shipped = Bool(shipped)
                    order.address1 = address1 as? String
                    order.address2 = address2 as? String
                    order.city = city as? String
                    order.state = state as? String
                    order.zip = zip as? String
                    order.notes = notes as? String
                    order.nameOnOrder = name
                    order.email = email as? String
            } else {
                print(jsonElement)
            }
            orders.add(order)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in self.delegate.itemsDownloaded(items: orders)})
    }
}
