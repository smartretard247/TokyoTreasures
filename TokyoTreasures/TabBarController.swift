//
//  TabBarController.swift
//  TokyoTreasures
//
//  Created by Jeezy on 4/2/17.
//  Copyright © 2017 Simply Silver AKY. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "American Typewriter", size: 15)!], for: .normal)
        
        self.tabBar.items?[0].titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -13)
        self.tabBar.items?[1].titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -13)
        self.tabBar.items?[1].title = "Shipping Calculator"
    }
}
