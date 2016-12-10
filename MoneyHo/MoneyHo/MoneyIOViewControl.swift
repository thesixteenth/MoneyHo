//
//  MoneyIOViewControl.swift
//  MoneyHo
//
//  Created by kwonHyunHo on 2016. 11. 19..
//  Copyright © 2016년 solsol. All rights reserved.
//

import Foundation
import UIKit
var databasePath = NSString()

class MoneyViewController : UIViewController {
    
    @IBOutlet weak var currentMoney: UITextField!
    var db  =  DBMethod()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deposit(_ sender: Any) {
        
        // 기존에 입금된 금액이랑 지금 입금된 금액을 더해서 DB에 넣어야 된다. (balance 값도 변경)
        
        db.money = Int(currentMoney.text!)!
        db.flag = true
        
    }
    
    
    @IBAction func withdraw(_ sender: UIButton){
        print("출금")
        
        db.money = Int(currentMoney.text!)!
        db.flag = true
    }
    
    @IBAction func closeView(_ sender: UIButton){
        print("닫기")
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("aaa")
        let destView = segue.destination as! DepositView
        let indexpath = self.db
        destView.db = indexpath
    
   }
}
