//
//  ShippingCalculatorController.swift
//  TokyoTreasures
//
//  Created by Jeezy on 4/2/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit

class ShippingCalculatorController: UIViewController {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var textCost: UITextField!
    @IBOutlet weak var labelShippingDescription: UILabel!
    @IBOutlet weak var textExchangeRate: UITextField!
    @IBOutlet weak var stepperExchangeRate: UIStepper!
    
    var sal: Bool = true
    var registered: Bool = true
    var usd: Bool = true
    let usdSymbol: String = "$ "
    let jpySymbol: String = "\u{00a5} "
    var rate: Double = 112.00
    let registeredCost: Int = 410
    var costUsd: Double = 0.00
    var costYen: Int = 0 //start with registered
    
    let salDescription: String = "San Francisco: About 2 weeks\nChicago: About 2 weeks\nNew York: About 2 weeks\nLos Angeles: About 2 weeks"
    let airmailDescription: String = "San Francisco: 8 days\nChicago: 5 days\nNew York: 7 days\nLos Angeles: 6 days"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedRate = loadExchangeRate()
        if (savedRate > 0) {
            self.rate = savedRate
        }
        
        self.thumbImage.image = UIImage(named: "JapanPost")
        self.textExchangeRate.text = "\(Int(rate))"
        self.textExchangeRate.isEnabled = false
        
        self.stepperExchangeRate.value = rate
        
        self.title = "Shipping Calculator"
        textCost.isEnabled = false
        textCost.text = "\(self.usdSymbol)" + (NSString(format: "%.2f", self.costUsd) as String) as String
        labelShippingDescription.text = salDescription
        
        self.textWeight.keyboardType = UIKeyboardType.numberPad
        self.textWeight.autocorrectionType = .no
        
        let textWeightView = UIView(frame: CGRect(x: 0, y: 0, width: 1 / UIScreen.main.scale, height: 1))
        textWeightView.backgroundColor = UIColor.lightGray
        self.textWeight.inputAccessoryView = textWeightView
        
        self.textWeight.becomeFirstResponder()
        calculate()
    }
    
    func loadExchangeRate() -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: "exchangeRate")
    }
    
    func saveExchangeRate() {
        let defaults = UserDefaults.standard
        defaults.set(rate, forKey: "exchangeRate")
    }
    
    @IBAction func oneClicker(sender: UIStepper) {
        self.rate = sender.value
        self.textExchangeRate.text = Int(sender.value).description
        calculate()
        self.saveExchangeRate()
    }
    
    @IBAction func back() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func clear() {
        textWeight.text = ""
        calculate()
    }
    
    @IBAction func calculate() {
        let weight: Double = Double(textWeight.text!) ?? 0.0
        costYen = Int(calcYen(weight))
        if(registered) {
            costYen += registeredCost
        }
        costUsd = Double(costYen) / rate
        if(usd) {
            textCost.text = "\(self.usdSymbol)" + (NSString(format: "%.2f", self.costUsd) as String) as String
        } else {
            textCost.text = "\(self.jpySymbol)\(self.costYen)"
        }
    }
    
    func calcYen(_ weight: Double) -> Double {
        if(sal) {
            let roundedWeight = round((weight + 50) / 100) * 100 //round up to nearest 100
            print("SAL Weight: \(roundedWeight)")
            return roundedWeight + 80.0
        } else {
            let roundedWeight = round((weight+25)/50) * 50 //round up to nearest 50
            print("Airmail Weight: \(roundedWeight)")
            return roundedWeight * 0.8 + roundedWeight + 60.0
        }
    }
    
    @IBAction func toggleCurrency() {
        usd = !usd
        calculate()
    }
    
    @IBAction func toggleRegistered() {
        registered = !registered
        calculate()
    }
    
    @IBAction func toggleMethod() {
        sal = !sal
        if(sal) {
            labelShippingDescription.text = salDescription
        } else {
            labelShippingDescription.text = airmailDescription
        }
        calculate()
    }
}
