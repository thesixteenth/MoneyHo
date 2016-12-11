//
//  DBMethod.swift
//  MoneyHo
//
//  Created by kwonHyunHo on 2016. 12. 6..
//  Copyright © 2016년 solsol. All rights reserved.
//

import Foundation


class DBMethod
{
    var money : Int = 0
    var flag : Bool = true
    
    func openDb() ->Void
    {
         let filemgr = FileManager.default
         let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
         
         databasePath = dirPaths[0].appendingPathComponent("MoneyHOS.db").path as NSString
         
         if filemgr.fileExists(atPath: databasePath as String) {
         return;
         }
         
         
         let contactDB = FMDatabase(path: databasePath as String)
         
         if contactDB == nil {
         print("Error: \(contactDB?.lastErrorMessage())")
         }
         
         if (contactDB?.open())! {
         let sql_stmt = "CREATE TABLE IF NOT EXISTS MONEYHOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, BALANCE TEXT, DEPOSIT TEXT, WITHDRAW TEXT, TOTALDEPOSIT TEXT, TOTALWITHDRAW TEXT, DATA TEXT)"
         if !(contactDB?.executeStatements(sql_stmt))! {
         print("Error ####: \(contactDB?.lastErrorMessage())")
         }
         
         //Table 생성 이후에 초기값으로 0 을 세팅 한다.
         
         contactDB?.close()
         } else {
         print("Error: \(contactDB?.lastErrorMessage())")
         }
    }
    
    func insertDeposit(money : Int)->Void{
        let contactDB = FMDatabase(path: databasePath as String)
        
        if !(contactDB?.open())! {
            print("Error @@@: \(contactDB?.lastErrorMessage())")
        }
        
        var currentBalance = String()
        var totalDeposit = String()
        
        // 잔액 및 전체 입금 금액 찾아오기  ID는 1 번 값만 사용한다.
        let querySQL = "SELECT BALANCE, TOTALDEPOSIT FROM MONEYHOS WHERE ID = 1"
        
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
        
        let convertBalance : Int = Int(currentBalance)!
        let convertCurrentMoney : Int = money
        
        let insertBalance : Int = convertBalance + convertCurrentMoney
        
        let convertTotalDeposit : Int = Int(totalDeposit)!
        let insertTotalDeposit : Int = convertTotalDeposit + convertCurrentMoney
        
        let insertSQL = "UPDATE MONEYHOS SET BALANCE = '\(String(insertBalance))',TOTALDEPOSIT = '\(String(insertTotalDeposit))' WHERE ID = 1"
        
        // 현재 입금 금액을 전체 입금 금액이랑 잔액에 더한 값을 넣는다.
        let result = contactDB?.executeUpdate(insertSQL,withArgumentsIn: nil)
        if !result! {
            print("Error !!!: \(contactDB?.lastErrorMessage())")
        }
        else {
            print("Success!!!")
        }
        
        //날자 별로 입금 금액을 전부 기억 하고 있어야 한다
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        var depositMoney = String()
        print(DateInFormat)
        
        if (contactDB?.open())! {
            
            // 현재 날자에 입금된 모든 금액을 가져 온다
            let querySQL = "SELECT DEPOSIT FROM MONEYHOS WHERE DATA = '\(DateInFormat)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                //입금된 금액에 현재 금액을 더한 값을 Insert한다
                depositMoney = (results?.string(forColumn: "DEPOSIT"))!
                depositMoney += "," + "\(money)"
            }
            else {
                print("Fail") // 입금된 금액이 없네?
                
                let insertSQL = "INSERT INTO MONEYHOS (BALANCE, DEPOSIT, WITHDRAW,TOTALDEPOSIT,TOTALWITHDRAW,DATA) VALUES ('0', '0', '0', '0', '0', '\(DateInFormat)')"
                
                contactDB?.executeUpdate(insertSQL,withArgumentsIn: nil)
                
                let insertSQL2 = "UPDATE MONEYHOS SET DEPOSIT = '\(depositMoney)' WHERE DATA= '\(DateInFormat)'"
                
                let result = contactDB?.executeUpdate(insertSQL2,
                                                      withArgumentsIn: nil)
                
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }
                else {
                }
            }
            
            print(depositMoney)
            let insertSQL2 = "UPDATE MONEYHOS SET DEPOSIT = '\(depositMoney)' WHERE DATA= '\(DateInFormat)'"
            
            let result = contactDB?.executeUpdate(insertSQL2,
                                                  withArgumentsIn: nil)
            
            if !result! {
                print("Error: \(contactDB?.lastErrorMessage())")
            }
            else {
            }
        }
    }
    
    func withdrawInsert (money :Int) -> Void{
        // 기존에 출금된 금액이랑 지금 출금된 금액을 더해서 DB에 넣어야 된다. (balance 값도 변경)
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            
            var currentBalance = String()
            var totalWithdraw = String()
            
            // 잔액 및 전체 출금 금액 찾아오기  ID는 1 번 값만 사용한다.
            
            let querySQL = "SELECT BALANCE, TOTALWITHDRAW FROM MONEYHOS WHERE ID = 1"
            
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
            
            if money != 0
            {
                let convertBalance : Int = Int(currentBalance)!
                let convertCurrentMoney : Int = money
                
                let insertBalance : Int = convertBalance - convertCurrentMoney
                
                print(insertBalance)
                
                let convertTotalWithdraw : Int = Int(totalWithdraw)!
                let insertTotalWithdraw : Int = convertTotalWithdraw + convertCurrentMoney
                
                print(insertTotalWithdraw)
                
                let insertSQL = "UPDATE MONEYHOS SET BALANCE = '\(String(insertBalance))',TOTALWITHDRAW = '\(String(insertTotalWithdraw))' WHERE ID = 1"
                
                
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
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        var withDrawMoney = String()
        print(DateInFormat)
        
        if (contactDB?.open())! {
            
            // 현재 날자에 입금된 모든 금액을 가져 온다
            let querySQL = "SELECT WITHDRAW FROM MONEYHOS WHERE DATA = '\(DateInFormat)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                //입금된 금액에 현재 금액을 더한 값을 Insert한다
                withDrawMoney = (results?.string(forColumn: "WITHDRAW"))!
                withDrawMoney += "," + "\(money)"
            }
            else {
                print("Fail")
                let insertSQL2 = "UPDATE MONEYHOS SET WITHDRAW = '\(withDrawMoney)' WHERE DATA= '\(DateInFormat)'"
                
                let result = contactDB?.executeUpdate(insertSQL2,
                                                      withArgumentsIn: nil)
                
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage())")
                }
                else {
                }
                
            }
            
            print(withDrawMoney)
            let insertSQL = "UPDATE MONEYHOS SET WITHDRAW = '\(withDrawMoney)' WHERE DATA= '\(DateInFormat)'"
            
            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            
            if !result! {
                print("Error: \(contactDB?.lastErrorMessage())")
            }
            else {
            }
        }
        
    }
    
    func selectBalance () -> Int{
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            
            var currentBalance = String()
            
            // 잔액 및 전체 출금 금액 찾아오기  ID는 1 번 값만 사용한다.
            
            let querySQL = "SELECT BALANCE FROM MONEYHOS WHERE ID = 1"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                currentBalance = (results?.string(forColumn: "BALANCE"))!
                var balance : Int = 0
                balance = Int(currentBalance)!
                NSLog("%d", balance)
                return balance
                
            }
            else {
                NSLog("Fail")
                return 0
            }
        }
        
        return 0
    }
    
}
