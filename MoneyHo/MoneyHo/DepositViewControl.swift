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
    
    var db  =  DBMethod()
    
    override func viewDidLoad() {
        db.openDb()
        if db.flag == true{
            db.insertDeposit(money: db.money)
        }
        else{
            db.withdrawInsert(money: db.money)
        }
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func DepositOk(_ sender: UIButton) {
        //입금 확인
        
    }
    
}
