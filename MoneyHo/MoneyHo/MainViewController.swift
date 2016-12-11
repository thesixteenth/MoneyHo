//
//  ViewController.swift
//  MoneyHo
//
//  Created by sol on 2016. 11. 15..
//  Copyright © 2016년 solsol. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var balance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DBMethod()
        
        db.openDb()
        
        var currentBalance :Int = 0
        
        currentBalance = db.selectBalance()
        
        balance.text = String(currentBalance)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        NSLog("cliked");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

