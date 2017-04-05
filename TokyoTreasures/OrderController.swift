//
//  OrderController.swift
//  TokyoTreasures
//
//  Created by Jeezy on 3/18/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit

class OrderController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerOrderSize: UIPickerView!
    @IBOutlet weak var pickerState: UIPickerView!
    @IBOutlet weak var textInvoicePrice: UITextField!
    @IBOutlet weak var textShipping: UITextField!
    @IBOutlet weak var textZip: UITextField!
    @IBOutlet weak var labelPaypalFee: UILabel!
    @IBOutlet weak var labelExpectingPayment: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress1: UITextField!
    @IBOutlet weak var textAddress2: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    
    var loadedOrder : OrderModel?
    
    let orderSizes = [
        ["","Small","Large","X-Large","Snacks","Other"]
    ]
    let states = [
        ["", "AA", "AE", "AK", "AL", "AP", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"]
    ]
    
    func loadOrder() {
        self.textInvoicePrice.text = NSString(format: "%.2f", self.loadedOrder!.invoicePrice!) as String
        self.textShipping.text = NSString(format: "%.2f", self.loadedOrder!.shipping!) as String
        self.textName.text = self.loadedOrder!.nameOnOrder
        self.textEmail.text = self.loadedOrder!.email ?? ""
        calcFee(invoicePrice: self.loadedOrder!.invoicePrice!)
        calcExpecting(invoicePrice: self.loadedOrder!.invoicePrice!)
        self.textAddress1.text = self.loadedOrder!.address1 ?? ""
        self.textAddress2.text = self.loadedOrder!.address2 ?? ""
        self.textCity.text = self.loadedOrder!.city ?? ""
        self.textZip.text = self.loadedOrder!.zip ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates and initialize homeModel
        self.pickerOrderSize.delegate = self
        self.pickerOrderSize.dataSource = self
        self.pickerState.delegate = self
        self.pickerState.dataSource = self
        
        self.textInvoicePrice.keyboardType = UIKeyboardType.decimalPad
        self.textShipping.keyboardType = UIKeyboardType.decimalPad
        self.textZip.keyboardType = UIKeyboardType.numberPad
        self.textEmail.keyboardType = UIKeyboardType.emailAddress
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrderController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OrderController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.textName.autocorrectionType = .no
        self.textAddress1.autocorrectionType = .no
        self.textAddress2.autocorrectionType = .no
        self.textCity.autocorrectionType = .no
        self.textEmail.autocorrectionType = .no
        
        if(self.loadedOrder != nil) {
            loadOrder()
            self.pickerState.selectRow(states[0].index(of: self.loadedOrder!.state ?? "")!, inComponent: 0, animated: true)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            self.datePicker.setDate(dateFormat.date(from: self.loadedOrder!.orderDate!)!, animated: true)
            
            self.pickerOrderSize.selectRow(orderSizes[0].index(of: (self.loadedOrder!.notes ?? ""))!, inComponent: 0, animated: true)
        }
        
        self.textName.autocapitalizationType = .words
        self.textAddress1.autocapitalizationType = .words
        self.textAddress2.autocapitalizationType = .words
        self.textCity.autocapitalizationType = .words
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (textName.isFirstResponder || textAddress1.isFirstResponder || textAddress2.isFirstResponder || textZip.isFirstResponder) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        self.view.frame.origin.y = 0
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.accessibilityIdentifier! {
        case "OrderSize": return orderSizes.count
        case "State": return states.count
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier! {
        case "OrderSize": return orderSizes[component].count
        case "State": return states[component].count
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier! {
        case "OrderSize": return orderSizes[component][row]
        case "State": return states[component][row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier! {
        case "OrderSize":
            switch orderSizes[component][row] {
            case "":
                textInvoicePrice.text = ""
                textShipping.text = ""
                labelPaypalFee.text = "?"
                labelExpectingPayment.text = "?"
            case "Small":
                textInvoicePrice.text = "28.00"
                textShipping.text = "8.00"
            case "Large":
                textInvoicePrice.text = "45.00"
                textShipping.text = "10.00"
            case "X-Large":
                textInvoicePrice.text = "83.00"
                textShipping.text = "13.00"
            case "Snacks":
                textInvoicePrice.text = "30.00"
                textShipping.text = "10.00"
            default: break
            }
            invoicePriceChanged(textInvoicePrice)
        default: break
        }
    }
    
    @IBAction func invoicePriceChanged(_ sender: UITextField) {
        if let price: Double = Double(sender.text!) {
            calcFee(invoicePrice: price)
            calcExpecting(invoicePrice: price)
        }
    }
    
    @IBAction func invoicePriceEditingDidEnd(_ sender: UITextField) {
        if let price: Double = Double(sender.text!) {
            calcFee(invoicePrice: price)
            calcExpecting(invoicePrice: price)
        }
        pickerOrderSize.selectRow(0, inComponent: 0, animated: true)
    }
    
    func calcFee(invoicePrice: Double) {
        if(textInvoicePrice.text != "") {
            let fee: Double = round((invoicePrice * 0.029 + 0.30) * 100)/100
            labelPaypalFee.text = NSString(format: "%.2f", fee) as String
        } else {
            labelPaypalFee.text = "?"
        }
    }
    
    func calcExpecting(invoicePrice: Double) {
        let fee: Double = invoicePrice * 0.029 + 0.30
        if(textInvoicePrice.text != "") {
            let expecting: Double = round((invoicePrice - fee) * 100)/100
            labelExpectingPayment.text = NSString(format: "%.2f", expecting) as String
        } else {
            labelExpectingPayment.text = "?"
        }
    }
    
    @IBAction func addOrder() {
        //test all inputs then send the sql to insert, go back to home and refresh
        let newOrder: OrderModel = OrderModel()
        if textInvoicePrice.text != "",
            textShipping.text != "",
            textName.text != "" {
            newOrder.email = textEmail.text
            newOrder.invoicePrice = Double(textInvoicePrice.text!)
            newOrder.shipping = Double(textShipping.text!)
            newOrder.nameOnOrder = textName.text
            newOrder.orderDate = String(describing: datePicker.date)
            newOrder.notes = String(self.orderSizes[0][pickerOrderSize.selectedRow(inComponent: 0)])
            newOrder.address1 = self.textAddress1.text
            newOrder.address2 = self.textAddress2.text
            newOrder.city = self.textCity.text
            newOrder.state = self.states[0][self.pickerState.selectedRow(inComponent: 0)]
            newOrder.zip = self.textZip.text
            if newOrder.notes == "" {
                newOrder.notes = "Other"
            }
            
            if (loadedOrder != nil) { // then do UPDATE
                let statement: String = "meth=up&name=\(newOrder.nameOnOrder!)&email=\(newOrder.email!)&invoice=\(newOrder.invoicePrice!)&shipping=\(newOrder.shipping!)&notes=\(newOrder.notes!)&id=\(loadedOrder!.id!)&add1=\(newOrder.address1!)&add2=\(newOrder.address2!)&city=\(newOrder.city!)&state=\(newOrder.state!)&zip=\(newOrder.zip!)&date=\(newOrder.orderDate!)"
                postToServer(statement) // execute statement here...
            } else { // do INSERT
                let statement: String = "meth=in&name=\(newOrder.nameOnOrder!)&email=\(newOrder.email!)&invoice=\(newOrder.invoicePrice!)&shipping=\(newOrder.shipping!)&notes=\(newOrder.notes!)&add1=\(newOrder.address1!)&add2=\(newOrder.address2!)&city=\(newOrder.city!)&state=\(newOrder.state!)&zip=\(newOrder.zip!)&date=\(newOrder.orderDate!)"
                postToServer(statement) // execute statement here...
            }
            
            let homeView = storyboard?.instantiateViewController(withIdentifier: "HomeController") as! ViewController
            homeView.navigationItem.setHidesBackButton(true, animated: true)
            navigationController!.pushViewController(homeView, animated: true)
        } else {
            //send message to user
            let alertController = UIAlertController(title: "Missing Data", message: "A field was left empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("A field was left empty.")
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func postToServer(_ statements: String) {
        let request = NSMutableURLRequest(url: NSURL(string: "http://203.105.90.20/ssa/update.php")! as URL)
        request.httpMethod = "POST"
        let postString = "\(statements)"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            //print("response = \(response)")
        }
        task.resume()
        //alert()
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Success", message: "Order was updated successfully.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("Order updated.")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
