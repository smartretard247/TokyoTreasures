//
//  TodayOrderController.swift
//  TokyoTreasures
//
//  Created by Jeezy on 3/18/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayOrderController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var textInvoice: UITextField!
    @IBOutlet weak var textShipping: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textState: UITextField!
    @IBOutlet weak var textZip: UITextField!
    var loadedOrder : OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(loadedOrder != nil) {
            textInvoice.text = NSString(format: "%.2f", self.loadedOrder!.invoicePrice!) as String
            textShipping.text = NSString(format: "%.2f", self.loadedOrder!.shipping!) as String
            textEmail.text = self.loadedOrder!.email ?? ""
            textName.text = self.loadedOrder!.nameOnOrder
            textAddress.text = self.loadedOrder!.address1 ?? ""
            textCity.text = self.loadedOrder!.city ?? ""
            textState.text = self.loadedOrder!.state ?? ""
            textZip.text = self.loadedOrder!.zip ?? ""
        }
        
        textInvoice.isEnabled = false
        textShipping.isEnabled = false
        textEmail.isEnabled = false
        textName.isEnabled = false
        textAddress.isEnabled = false
        textCity.isEnabled = false
        textState.isEnabled = false
        textZip.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TodayOrderController.exit))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
