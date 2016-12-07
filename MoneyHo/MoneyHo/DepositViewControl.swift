//
//  DepositViewControl.swift
//  MoneyHo
//
//  Created by kwonHyunHo on 2016. 11. 23..
//  Copyright © 2016년 solsol. All rights reserved.
//

import Foundation
import UIKit

class DepositView : UIViewController{
    
    var temp : String = ""
    
    override func viewDidLoad() {
        
        let db  =  DBMethod()
        db.openDb()
        
        db.insertDeposit(money: 10000)
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func DepositOk(_ sender: UIButton) {
        //입금 확인
        
    }
    
}
