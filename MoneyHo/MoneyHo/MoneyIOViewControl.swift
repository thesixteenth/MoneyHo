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

class MoneyViewController : UIViewController
{
    @IBOutlet weak var currentMoney: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("MoneyHO.db").path as NSString
        
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB?.lastErrorMessage())")
            }
            
            if (contactDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS MONEYHO (ID INTEGER PRIMARY KEY AUTOINCREMENT, BALANCE TEXT, DEPOSIT TEXT, WITHDRAW TEXT, TOTALDEPOSIT TEXT, TOTALWITHDRAW TEXT)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print("Error ####: \(contactDB?.lastErrorMessage())")
                }
                
                //Table 생성 이후에 초기값으로 0 을 세팅 한다.
                
                contactDB?.close()
            } else {
                print("Error: \(contactDB?.lastErrorMessage())")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deposit(_ sender: Any)
    {
        // 기존에 입금된 금액이랑 지금 입금된 금액을 더해서 DB에 넣어야 된다. (balance 값도 변경)
        print("입금")
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {

            var currentBalance = String()
            var totalDeposit = String()
            
            // 잔액 및 전체 입금 금액 찾아오기  ID는 1 번 값만 사용한다.
            let querySQL = "SELECT BALANCE, TOTALDEPOSIT FROM MONEYHO WHERE ID = 1"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
            withArgumentsIn: nil)
             
            if results?.next() == true {
                currentBalance = (results?.string(forColumn: "BALANCE"))!
                print(currentBalance)
                totalDeposit = (results?.string(forColumn: "TOTALDEPOSIT"))!
                print(totalDeposit)
            }
            else {
                print("Fail")
            }
            
            if currentMoney.text! != ""
            {
                let convertBalance : Int = Int(currentBalance)!
                let convertCurrentMoney : Int = Int(currentMoney.text!)!
                
                let insertBalance : Int = convertBalance + convertCurrentMoney
                
                let convertTotalDeposit : Int = Int(totalDeposit)!
                let insertTotalDeposit : Int = convertTotalDeposit + convertCurrentMoney
                
                let insertSQL = "UPDATE MONEYHO SET BALANCE = '\(String(insertBalance))',TOTALDEPOSIT = '\(String(insertTotalDeposit))' WHERE ID = 1"
                
                
                // 현재 입금 금액을 전체 입금 금액이랑 잔액에 더한 값을 넣는다.
                let result = contactDB?.executeUpdate(insertSQL,withArgumentsIn: nil)
                
                if !result! {
                    print("Error !!!: \(contactDB?.lastErrorMessage())")
                }
                else {
                    print("Success!!!")
                }
            }
            
        }
        else {
            print("Error @@@: \(contactDB?.lastErrorMessage())")
            
        }

        
    }
    @IBAction func withdraw(_ sender: UIButton)
    {
        print("출금")
        // 기존에 출금된 금액이랑 지금 출금된 금액을 더해서 DB에 넣어야 된다. (balance 값도 변경)
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            
            var currentBalance = String()
            var totalWithdraw = String()
            
            // 잔액 및 전체 출금 금액 찾아오기  ID는 1 번 값만 사용한다.
            
            let querySQL = "SELECT BALANCE, TOTALWITHDRAW FROM MONEYHO WHERE ID = 1"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                currentBalance = (results?.string(forColumn: "BALANCE"))!
                print(currentBalance)
                totalWithdraw = (results?.string(forColumn: "TOTALWITHDRAW"))!
                print(totalWithdraw)
            }
            else {
                print("Fail")
            }
 
            if currentMoney.text! != ""
            {
                let convertBalance : Int = Int(currentBalance)!
                let convertCurrentMoney : Int = Int(currentMoney.text!)!
                
                let insertBalance : Int = convertBalance - convertCurrentMoney
                
                print(insertBalance)
                
                let convertTotalWithdraw : Int = Int(totalWithdraw)!
                let insertTotalWithdraw : Int = convertTotalWithdraw + convertCurrentMoney
                
                print(insertTotalWithdraw)
                
                let insertSQL = "UPDATE MONEYHO SET BALANCE = '\(String(insertBalance))',TOTALWITHDRAW = '\(String(insertTotalWithdraw))' WHERE ID = 1"
                
                
                // 현재 출금 금액을 전체 출금 금액이랑 잔액에 뺀 값을 넣는다.
                let result = contactDB?.executeUpdate(insertSQL,withArgumentsIn: nil)
                
                if !result! {
                    print("Error !!!: \(contactDB?.lastErrorMessage())")
                }
                else {
                    print("Success!!!")
                }
            }
            
        }
        else {
            print("Error @@@: \(contactDB?.lastErrorMessage())")
            
        }


    }
    @IBAction func closeView(_ sender: UIButton)
    {
        print("닫기")
    }
}
