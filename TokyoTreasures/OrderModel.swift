//
//  LocationModel.swift
//  TokyoTreasures
//
//  Created by Jeezy on 3/17/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import Foundation

class OrderModel: NSObject {
    //properties
    var id: Int?
    var nameOnOrder: String?
    var orderDate: String?
    var invoicePrice: Double?
    var shipping: Double?
    var fee: Double?
    var profit: Double?
    var expecting: Double?
    var processed: Bool?
    var shipped: Bool?
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var zip: String?
    var notes: String?
    var email: String?
    
    //empty constructor
    override init() {}
    
    //construct with @name, @orderDate, @invoicePrice parameters
    init(id: Int, name: String, orderDate: String, invoicePrice: Double, shipping: Double, fee: Double, profit: Double, expecting: Double, processed: Bool, shipped: Bool, address1: String?, address2: String, city: String, state: String, zip: String, notes: String, email: String) {
        self.id = id
        self.nameOnOrder = name
        self.orderDate = orderDate
        self.invoicePrice = invoicePrice
        self.shipping = shipping
        self.fee = fee
        self.profit = profit
        self.expecting = expecting
        self.processed = processed
        self.shipped = shipped
        self.address1 = address1 ?? ""
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.notes = notes
        self.email = email
    }
    
    //prints object's current state
    override var description: String {
        return "Order Date: \(orderDate!), Name: \(nameOnOrder!), Invoice Price: \(invoicePrice!), State/Zip: \(state), \(zip), Notes: \(notes)"
    }
}
